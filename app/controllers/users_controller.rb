class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :set_current_user, only: [:import, :create]

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
    @training = Training.new
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
    if @user.save
      raw, token = Devise.token_generator.generate(User, :reset_password_token)
      @user.reset_password_token = token
      @user.reset_password_sent_at = Time.now.utc
      @user.save(validate: false)
      # @user.send_reset_password_instructions
      UserMailer.account_created(@user, raw).deliver
      redirect_to user_path(@user)
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
    if @user.save
      redirect_to user_path(@user)
    else
      render "_edit"
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
    begin
      @users = User.import(params[:file])
      flash[:notice] = 'Import terminé'
      redirect_back(fallback_location: root_path)
    rescue
      redirect_back(fallback_location: root_path)
      flash[:error] = "An error has occured. Please check your csv file."
    end
  end

  # Allows to scrape data from the current user Linkedin profile
  # def linkedin_scrape
  #   skip_authorization
  #   oauth = LinkedIn::OAuth2.new
  #   url = oauth.auth_code_url
  #   redirect_to "#{url}"
  # end

  # def linkedin_scrape_callback
  #   skip_authorization
  #   oauth = LinkedIn::OAuth2.new
  #   code = params[:code]
  #   access_token = oauth.get_access_token(code)
  #   api = LinkedIn::API.new(access_token)
  #   client = RestClient
  #   # Updates User picture with his(her) Linkedin profile picture.
  #   url = 'https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))'
  #   res = RestClient.get(url, Authorization: "Bearer #{access_token.token}")
  #   picture_url = res.body.split('"').select{ |i| i[/https:\/\/media\.licdn\.com\/dms\/image\/.*/]}.last
  #   current_user.update(picture: picture_url)

  #   redirect_to user_path(current_user)
  # end

  private

  def set_current_user
    Current.user = current_user
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password, :access_level, :birth_date, :hire_date, :termination_date, :address, :phone_number, :social_security, :gender, :picture, :linkedin, :job_description, :company_id)
  end

  def index_function(parameter)
    if current_user.access_level == 'Super Admin'
      if params[:search]
        @users = (parameter.where('lower(firstname) LIKE ?', "%#{params[:search][:name].downcase}%") + parameter.where('lower(lastname) LIKE ?', "%#{params[:search][:name].downcase}%"))
        @users = @users.sort_by{ |user| user.lastname } if @users.present?
      else
        @users = parameter.order('lastname ASC')
      end
    elsif current_user.access_level == 'HR'
      if params[:search]
        @users = (parameter.where(company_id: current_user.company.id).where('lower(firstname) LIKE ?', "%#{params[:search][:name].downcase}%") + parameter.where('lower(lastname) LIKE ?', "%#{params[:search][:name].downcase}%"))
        @users = @users.sort_by{ |user| user.lastname } if @users.present?
      else
        @users = parameter.where(company_id: current_user.company.id).order('lastname ASC')
      end
    end
  end
end
