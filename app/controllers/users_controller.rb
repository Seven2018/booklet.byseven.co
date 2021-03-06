class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  before_action :set_current_user, only: [:import, :create]
  skip_before_action :verify_authenticity_token, only: [:update]

  # Show user profile (users/show)
  def show
    if ['Super Admin', 'Account Owner'].include?(current_user.access_level)
      @user = User.find(params[:id])
    elsif current_user.access_level == 'HR'
      @user = User.where(company_id: current_user.company_id).find(params[:id])
    else
      @user = current_user
    end
    authorize @user
  end

  # Create new User (user_registration, pages/organisation)
  def create
    @user = User.new(user_params)
    @user.picture = 'https://i0.wp.com/rouelibrenmaine.fr/wp-content/uploads/2018/10/empty-avatar.png' if @user.picture == ''
    @user.company_id = current_user.company_id
    authorize @user
    tags = params[:user][:tags].reject{|x| x.empty?}.map{|c| c.to_i} if params[:user][:tags].present?
    if @user.save
      if tags.present?
        tags.each do |tag|
          UserTag.create(user_id: @user.id, tag_id: tag)
        end
      end
      redirect_to organisation_path
    else
      render :new
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
      redirect_to dashboard_path, notice: "Your account is now linked to #{company.name}"
    else
      redirect_to dashboard_path, notice: "An error has occured, please check the provided url link."
    end
  end

  # Update user profile (users/show)
  def update
    authorize @user
    if params[:type] == 'address'
      address = params[:user][:address]
      address = address.gsub(address.split(/\d+/)[-2], address.split(/\d+/)[-2][0..-2] + "\n")
      @user.update(address: address)
    else
      @user.update(user_params)
    end
    if params[:user][:tags].present?
      tags = params[:user][:tags].reject{|x| x.empty?}.map{|c| c.to_i}
      del_tags = Tag.where(company_id: current_user.company_id).map(&:id) - tags
    end
    if @user.save
      if params[:user][:tags].present?
        UserTag.where(user_id: @user.id, tag_id: del_tags).destroy_all
        tags.each do |tag|
          UserTag.create(user_id: @user.id, tag_id: tag)
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

  # Remove user
  def destroy
    authorize @user
    @user.destroy
    redirect_to organisation_path
  end

  # Creates new Users from an imported list
  def import
    skip_authorization
    errors = []
    creating = []
    CSV.foreach(params[:file].path, headers: true) do |row|
      user_row = row.to_hash
      if !user_row['email'].present?
        errors << "#{user_row[:lastname]}, #{user_row[:firstname]}"
      elsif User.find_by(email: user_row['email']).nil?
        creating << "#{user_row[:lastname]}, #{user_row[:firstname]}"
      end
    end
    if errors.count > 0
      flash[:notice] = "Creating #{creating.count} new accounts. Please wait a few minutes and refresh this page. \n There is #{errors.count} users with missing email addresses. No account will be created for these users."
    else
      flash[:notice] = "Creating #{creating.count} new accounts. Please wait a few minutes and refresh this page."
    end
    ImportEmployeesJob.perform_async(params[:file], current_user.company_id)
    redirect_back(fallback_location: root_path)
  end

  # Search from users with autocomplete
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
end
