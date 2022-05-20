# Updated : 2021/07/19

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :add_tag_category_tags]
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
    @user = User.new(user_params)
    authorize @user

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
        tag_category = TagCategory.find_by(name: tag_category_name)

        UserTag.create(
          user: @user,
          tag_category: tag_category,
          tag: Tag.find_by(tag_name: tag_name, tag_category: tag_category)
        )
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
    if params[:type] == 'address'
      address = params[:user][:address].gsub(address.split(/\d+/)[-2], address.split(/\d+/)[-2][0..-2] + "\n")
      @user.update(address: address)
    else
      @user.update(user_params)
    end

    if @user.save
      if params[:access_level_int].present?
        if params[:last_page] == "catalogue"
          redirect_to catalogue_path
        elsif ['campaigns', 'interview_forms'].include?(params[:last_page].split('-').first)
          redirect_to campaigns_path
        else
          redirect_to root_path
        end
      else
        respond_to do |format|
          if params[:page] != 'show'
            format.html { redirect_to user_path(@user) }
          else
            format.html { redirect_to organisation_path }
            format.js
          end
        end
      end
    end
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
        if !user_row['email'].present? || (user_row['email'].strip.downcase =~ /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/).nil?
          @errors << row
        elsif user.nil?
          @creating << row
          present << user_row['email'].downcase
        else
          next if user.company_id != current_user.company_id
          user_row.each do |key, value|
            # begin
            user_tag = user.user_tags.find_by(tag_category_id: TagCategory.find_by(name: key)&.id)
            if (user.attributes.key?(key) && (user.attributes[key].class == Date ? user.attributes[key].strftime('%d/%m/%Y') != value : (user.attributes[key]&.strip&.downcase != value&.strip&.downcase)))
              @updating << { lastname: user.lastname, firstname: user.firstname, former: user.attributes[key], new: value }
            elsif (user_tag.present? && user_tag.tag_category.name.capitalize == key.capitalize && user_tag.tag.tag_name.capitalize != value.capitalize)
              @updating << { lastname: user.lastname, firstname: user.firstname, former: user_tag.tag.tag_name, new: value }
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

  # Search from users with autocomplete
  def users_search
    skip_authorization

    @users =
      if params[:manager].present?
        User.where(company_id: current_user.company_id, access_level_int: [:manager, :hr, :admin])
      else
        User.where(company_id: current_user.company_id)
      end

    @users = @users.ransack(firstname_or_lastname_cont: params[:search]).result(distinct: true)

    respond_to do |format|
      format.html {}
      format.json {
        @users = @users.limit(5)
      }
    end
  end

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
