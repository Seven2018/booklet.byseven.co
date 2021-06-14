class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :set_current_user, only: [:import, :create]
  skip_before_action :verify_authenticity_token, only: [:update]

  def index
    # Index with 'search' option and global visibility for SEVEN Users
    index_function(policy_scope(User))
    # Index for other Users, with visibility limited to programs proposed by their company only
    if current_user.access_level == 'HR'
      @Tags = Tag.joins(:company).where(companies: { name: current_user.company.name })
      if params[:search]
        @Tags = @Tags.where("lower(name) LIKE ?", "%#{params[:search][:name].downcase}%").order(name: :asc)
      end
    end
  end

  def show
    if ['Super Admin', 'Admin'].include?(current_user.access_level)
      @user = User.find(params[:id])
    elsif current_user.access_level == 'HR'
      @user = User.where(company_id: current_user.company_id).find(params[:id])
    else
      @user = current_user
    end
    authorize @user
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    @user.picture = 'https://i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png' if @user.picture == ''
    @user.company_id = current_user.company_id
    authorize @user
    tags = params[:user][:tags].reject{|x| x.empty?}.map{|c| c.to_i} if params[:user][:tags].present?
    if @user.save
      #raw, token = Devise.token_generator.generate(User, :reset_password_token)
      #@user.reset_password_token = token
      #@user.reset_password_sent_at = Time.now.utc
      #@user.save(validate: false)
      if tags.present?
        tags.each do |tag|
          UserTag.create(user_id: @user.id, tag_id: tag)
        end
      end
      # @user.send_reset_password_instructions
      # UserMailer.account_created(@user, raw).deliver
      redirect_to organisation_path
    else
      render :new
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    @user.update(user_params)
    if params[:user][:tags].present?
      tags = params[:user][:tags].reject{|x| x.empty?}.map{|c| c.to_i}
      del_tags = Tag.where(company_id: current_user.id).map(&:id) - tags
    end
    if @user.save
      if tags.present?
        tags.each do |tag|
          UserTag.create(user_id: @user.id, tag_id: tag)
          UserTag.where(user_id: @user.id, tag_id: del_tags).destroy_all
        end
      end
      respond_to do |format|
        if params[:page] != 'show'
          format.html {redirect_to user_path(@user)}
        else
          format.html {redirect_to user_path(@user)}
          format.js
        end
      end
    end
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to organisation_path
  end

  # Creates new Users from an imported list
  def import
    skip_authorization
    errors = []
    CSV.foreach(params[:file].path, headers: true) do |row|
      user_row = row.to_hash
      if !user_row['email'].present?
        errors << "#{user_row[:lastname]}, #{user_row[:firstname]}"
      end
    end
    flash[:error] = "There is #{errors.count} users with missing email addresses. No account will be created for these users."
    #begin
    #  @users = User.import(params[:file])
    #  flash[:notice] = 'Import terminé'
    #  redirect_back(fallback_location: root_path)
    #rescue
    #  redirect_back(fallback_location: root_path)
    #  flash[:error] = "An error has occured. Please check your csv file."
    #end
    ImportEmployeesJob.perform_async(params[:file], current_user.company_id)
    redirect_back(fallback_location: root_path)
  end

  def users_search
    skip_authorization
    @users = User.ransack(firstname_or_lastname_cont: params[:search]).result(distinct: true)
    respond_to do |format|
      format.html{}
      format.json {
        # render json: @users
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
    params.require(:user).permit(:firstname, :lastname, :email, :password, :access_level, :birth_date, :hire_date, :termination_date, :address, :phone_number, :social_security, :gender, :picture, :linkedin, :job_title, :company_id)
  end

  def index_function(parameter)
    if ['super admin', 'HR'].includes?(current_user.access_level)
      raise
      if params[:search].present?
        @users = (parameter.where(company_id: current_user.company.id).where('lower(firstname) LIKE ?', "%#{params[:search][:name].downcase}%") + parameter.where('lower(lastname) LIKE ?', "%#{params[:search][:name].downcase}%"))
        @users = @users.sort_by{ |user| user.lastname } if @users.present?
      elsif params[:filter].present?
        @users = (parameter.joins(:user_tags).where(company_id: current_user.company_id, user_tags: {tag_id: Tag.where(tag_name: params[:filter][:tag].reject(&:blank?)).map{|x| x.id}}))
      else
        @users = parameter.where(company_id: current_user.company.id).order('lastname ASC')
      end
    end
  end
end
