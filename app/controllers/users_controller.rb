# Updated : 2021/07/19

class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  before_action :set_current_user, only: [:import, :create]
  skip_before_action :verify_authenticity_token, only: [:update]

  # Show user profile (users/show)
  def show
    @user = User.find(params[:id])
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
      address = params[:user][:address].gsub(address.split(/\d+/)[-2], address.split(/\d+/)[-2][0..-2] + "\n")
      @user.update(address: address)
    elsif params[:access_level].present?
      @user.update(access_level: params[:access_level])
    else
      @user.update(user_params)
    end
    unless params[:user].nil?
      if params[:user][:tags].present?
        tags = params[:user][:tags].reject{|x| x.empty?}.map{|c| c.to_i}
        del_tags = Tag.where(company_id: current_user.company_id).map(&:id) - tags
      end
    end
    if @user.save
      unless params[:user].nil?
        if params[:user][:tags].present?
          UserTag.where(user_id: @user.id, tag_id: del_tags).destroy_all
          tags.each do |tag|
            UserTag.create(user_id: @user.id, tag_id: tag, tag_category_id: Tag.find(tag).tag_category_id)
          end
        end
      end
      if params[:access_level].present?
        if params[:last_page] == "catalogue"
          redirect_to catalogue_path
        else
          redirect_to root_path
        end
      else
        respond_to do |format|
          if params[:page] != 'show'
            format.html {redirect_to user_path(@user)}
          else
            format.html {redirect_to organisation_path}
            format.js
          end
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

  def import_users
    skip_authorization
    return unless ['Super Admin', 'Account Owner', 'HR'].include?(current_user.access_level)
    if params[:button] == 'summary'
      @errors = []
      @creating = []
      @updating = []
      present = []
      CSV.foreach(params[:file].path, headers: true) do |row|
        user_row = row.to_hash
        user = User.find_by(email: user_row['email']&.downcase)
        if !user_row['email'].present? || (user_row['email'].downcase =~ /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/).nil?
          @errors << row
        elsif user.nil?
          @creating << row
          present << user_row['email'].downcase
        else
          continue if user.company_id != current_user.company_id
          user_row.each do |key, value|
            user_tag = user.user_tags.find_by(tag_category_id: TagCategory.find_by(name: key)&.id)
            if (user.attributes.key?(key) == true && user.attributes[key].downcase != value.downcase)
              @updating << {lastname: user.lastname, firstname: user.firstname, former: user.attributes[key], new: value}
            elsif  (user_tag.present? && user_tag.tag_category.name.capitalize == key.capitalize && user_tag.tag.tag_name.capitalize != value.capitalize)
              @updating << {lastname: user.lastname, firstname: user.firstname, former: user_tag.tag.tag_name, new: value}
            end
          end
          present << user_row['email'].downcase
        end
      end
      @deleting = User.where(email: (User.where(company_id: current_user.company_id).map{|x| x.email.downcase} - present))
      @file = params[:file]
      respond_to do |format|
        format.html {redirect_back(fallback_location: root_path)}
        format.js
      end
    elsif params[:button] == 'import'
      @redirect = request.base_url + request.path
      ImportEmployeesJob.perform_async(params[:file], current_user.company_id)
      flash[:notice] = 'Import in progress. Please wait for a while and refresh this page.'
      flash.keep(:notice)
      render js: "window.location = '#{organisation_path}'"
    end
  end

  # Search from users with autocomplete
  def users_search
    skip_authorization
    @users = User.where(company_id: current_user.company_id).order(lastname: :asc).ransack(firstname_or_lastname_cont: params[:search]).result(distinct: true)
    respond_to do |format|
      format.html{}
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
    params.require(:user).permit(:firstname, :lastname, :email, :password, :access_level, :birth_date, :hire_date, :termination_date, :address, :phone_number, :social_security, :gender, :picture, :linkedin, :job_title, :company_id)
  end
end
