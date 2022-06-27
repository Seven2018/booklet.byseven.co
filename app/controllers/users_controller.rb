class UsersController < ApplicationController
  before_action :set_user, only: [:show, :reset_password, :edit, :update, :destroy, :add_tag_category_tags]
  before_action :set_current_user, only: [:import, :create]
  skip_before_action :verify_authenticity_token, only: [:update]
  before_action :show_navbar_home

  # Show user profile (users/show)
  def show
    authorize @user

    trainings = Training.joins(sessions: :attendees).where(attendees: { user: @user }).distinct
    @trainings_current = trainings.where_exists(:attendees, user: current_user, status: 'Not completed')
    @trainings_completed = trainings.where_not_exists(:attendees, user: current_user, status: 'Not completed')

    campaigns = Campaign.where(company: @user.company).order(created_at: :desc).where \
      id: Interview.where(employee: @user).distinct.pluck(:campaign_id)
    @campaigns_current = campaigns.where_exists(:interviews, locked_at: nil)
    @campaigns_completed = campaigns.where_not_exists(:interviews, locked_at: nil)
  end

  # Create new User (user_registration, pages/organisation)
  def create
    @user = User.find_by(email: params.dig(:user, :email).strip.downcase).presence || User.new(user_params)
    authorize @user

    if @user.id.present?
      @user.update company_id: current_user.company_id if @user.company_id.nil?
    else
      @user.lastname = @user.lastname.upcase
      @user.firstname = @user.firstname.capitalize
      @user.picture = 'https://i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png' if @user.picture == ''
      @user.company_id = current_user.company_id
      @user.authentication_token = Base64.encode64(@user.email).gsub("\n", "") + SecureRandom.hex(32)

      new_user = User.find_by(email: params.dig(:user, :email)).nil?
      send_invite = params.dig(:user, :send_invite) == 'true'

      # Send invitation
      if new_user
        if send_invite
          @user.save(validate: false)
          @user.invite!
        else
          @user.save(validate: false)
        end

        params[:tags].each do |tag_category_name, tag_name|
          tag_category = TagCategory.find_by(name: tag_category_name, company: current_user.company)

          UserTag.create(
            user: @user,
            tag_category: tag_category,
            tag: Tag.find_by(tag_name: tag_name, tag_category: tag_category)
          )
        end if params[:tags].present?
      end
    end

    respond_to do |format|
      format.html { redirect_to organisation_path }
      format.js
    end
  end

  # Ask user to complete his/her profile after account creation (user_registration)
  def complete_profile
    @user = current_user
    authorize @user
  end

  # Link user to selected company, via provided url
  def link_to_company
    skip_authorization
    company = Company.find_by(auth_token: params[:auth_token])
    if company.present?
      current_user.update(company_id: company.id)
      redirect_to trainings_path, notice: "Your account is now linked to #{company.name}"
    else
      redirect_to trainings_path, notice: "An error has occured, please check the provided url link."
    end
  end

  def unlink_from_company
    selected_users_ids = params[:selected_users].split(',')
    selected_users = User.where(id: selected_users_ids)
    authorize selected_users

    selected_users.each do |user|
      user.update company_id: nil
      user.user_tags.destroy_all

      CampaignDraft.select{|x| x.interviewee_ids.include?(user.id.to_s)}.each do |draft|
        data = draft.data
        data['interviewee_ids'] = draft.interviewee_ids - [user.id.to_s]
        draft.update(data: data, interviewee_ids: data['interviewee_ids'])
      end

      TrainingDraft.select{|x| x.participant_ids.include?(user.id.to_s)}.each do |draft|
        data = draft.data
        data['participant_ids'] = draft.participant_ids - [user.id.to_s]
        draft.update(data: data, participant_ids: data['participant_ids'])
      end
    end

    @selected_users = params[:selected_users]

    respond_to do |format|
      format.html { redirect_to organisation_path }
      format.js {}
    end
  end

  def edit
    authorize @user
    @tag_categories = TagCategory.distinct.where(company: @user.company).joins(:tags)
  end

  # Update user profile (users/show)
  def update
    authorize @user

    @user.update(user_params)

    job_title_tag_category = @user.company.tag_categories.find_by(name: 'Job Title')
    @user.update(job_title: UserTag.find_by(tag_category_id: job_title_tag_category.id,
                                            user_id: @user.id).tag.tag_name) if job_title_tag_category.present?

    redirect_to user_path(@user)
  end

  def add_tag_category_tags
    authorize @user
    tag_category = TagCategory.find(params.require(:tag_category_id))
    tag = Tag.find_by(id: params[:tag_id])
    tag = Tag.create(
      tag_name: params.require(:tag_name),
      company: @user.company,
      tag_category: tag_category) if tag.nil?

    UserTag.where(user: @user, tag_category: tag_category).delete_all
    UserTag.create(user: @user, tag_category: tag_category, tag: tag)
  end

  # Remove user
  def destroy
    authorize @user
    @user.destroy
    redirect_to organisation_path
  end

  def import_users
    skip_authorization
    return unless UserPolicy.new(current_user, nil).create?

    if params[:button] == 'summary'
      @errors = []
      @creating = []
      @updating = []
      present = []
      CSV.foreach(params[:file].path, headers: true) do |row|

        user_row = row.to_hash
        user = User.find_by(email: user_row['email']&.strip&.downcase)

        if !user_row['email'].present? ||
          (user_row['email'].strip.downcase =~ /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/).nil? ||
          (user.company_id.present? && (user.company_id != current_user.company_id))

          @errors << row

        elsif user.nil?

          @creating << row
          present << user_row['email'].downcase

        else

          user_row.each do |key, value|
            # begin
            user_tag = user.user_tags.find_by(tag_category_id: TagCategory.find_by(name: key)&.id)
            if (user.attributes.key?(key) && (user.attributes[key].class == Date ? user.attributes[key].strftime('%d/%m/%Y') != value : (user.attributes[key]&.strip&.downcase != value&.strip&.downcase)))
              @updating << { lastname: user.lastname, firstname: user.firstname, former: user.attributes[key], new: value }
            elsif (user_tag.present? && user_tag.tag_category.name.capitalize == key.capitalize && user_tag.tag.tag_name.capitalize != value.capitalize)
              @updating << { lastname: user.lastname, firstname: user.firstname, former: user_tag.tag.tag_name, new: value }
            elsif user.company_id.nil?
              @updating << { lastname: user.lastname, firstname: user.firstname, former: '', new: current_user.company.name }
            end
            # rescue
            # end
          end
          present << user_row['email'].downcase

        end

      end
      # pause_deleting_employees_on_csv_import
      # @deleting = User.where(email: (User.where(company_id: current_user.company_id).map{|x| x.email.downcase} - present))
      @deleting = User.none
      @file = params[:file]
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path) }
        format.js
      end
    elsif params[:button] == 'import'
      @redirect = request.base_url + request.path

      csv_import_user = CsvImportUser.create creator: current_user, data: CSV.foreach(params[:file], headers: true).map(&:to_h)
      ImportEmployeesJob.perform_later(csv_import_user.id, params[:send_invite] == 'true')
      flash[:notice] = 'Import in progress. Please wait for a while and refresh this page.'
      flash.keep(:notice)
      render js: "window.location = '#{organisation_path}'"
    end
  end


  #########################
  ## SEARCH AUTOCOMPLETE ##
  #########################

  def users_search
    skip_authorization

    @users =
      if params[:manager].present?
        User.where(company_id: current_user.company_id, access_level_int: [:manager, :hr, :account_owner, :admin])
      else
        User.where(company_id: current_user.company_id)
      end

    if params[:manager].present?
      @users = User.where(id: Campaign.find(params[:campaign_id]).interviewers.uniq.map(&:id)) if params[:campaign_id].present?
    else
      @users = @users.where_exists(:interviews, campaign_id: params[:campaign_id]) if params[:campaign_id].present?
      @users = @users.where_not_exists(:interviews, campaign_id: params[:not_campaign_id]) if params[:not_campaign_id].present?
    end

    @users = @users.ransack(firstname_or_lastname_cont: params[:search]).result(distinct: true).map{|x| [x.id, x.fullname]}

    render partial: 'shared/tools/select_autocomplete', locals: { elements: @users }
  end

  def managers_search
    skip_authorization

    users = User.where(company_id: current_user.company_id, access_level_int: [:manager, :hr, :account_owner, :admin])
    users = users.search_users(params[:text]) if params[:text].present?

    render json: users, status: :ok
  end


  #########################

  private

  def set_current_user
    Current.user = current_user
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :access_level_int,
      :manager_id, :birth_date, :hire_date, :termination_date, :address,
      :phone_number, :social_security, :gender, :picture, :linkedin, :job_title,
      :company_id, :reset_password_token, :password, :password_confirmation)
  end
end
