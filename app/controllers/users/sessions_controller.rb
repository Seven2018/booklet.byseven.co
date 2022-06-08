# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  layout 'devise'

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super
  end

  def check
    @user = User.find_by(email)

    return render 'devise/sessions/not_found', locals: email if @user.nil?
    render 'devise/sessions/email_sent' if @user.encrypted_password.nil?
  end

  def resend_email
    if params[:email].blank?
      @user = OpenStruct.new({email: ''})
      render 'devise/sessions/email_sent', alert: 'Were facing a problem'
    else
      @user = User.find_by(email: params[:email])
      @user.invite! if @user.present?
      render 'devise/sessions/email_sent', notice: 'Email sent'
    end
  end

  def reset_password
    @user = User.find_by(email: params.dig(:email))

    @user.reset_password!

    respond_to do |format|
      format.js
    end
  end

  def auth_options
    { scope: resource_name, recall: "#{controller_path}#check" }
  end

  private

  def email
    params.require(:user)
          .permit(:email)
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
