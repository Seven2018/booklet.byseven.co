class UserMailer < ApplicationMailer
  default from: CompanyInfo.no_reply
  layout 'basic_mailer'

  def account_created(user, raw_token)
    @user = user
    @token = raw_token
    @icon = '👋'
    @title = "Hello, #{@user.fullname}"
    @description = "Your have been invited to join Booklet !\n Click here to create your password"
    @button_text = "Create my password"
    @button_link = accept_user_invitation_url(@user, invitation_token: @token)

    mail(to: @user.email, subject: 'Welcome to Booklet !')
  end

  def reset_password(user, raw_token)
    @user = user
    @token = raw_token
    @icon = '👋'
    @title = "Hello, #{@user.fullname}"
    @description = "It seems you have forgotten your password on Booklet,\n please click the following link to reset it easily."
    @button_text = "Reset my password"
    @button_link = accept_user_invitation_url(@user, invitation_token: @token, reset_password: true)
    @nb = "If you have not requested a password reset, please ignore this email."

    mail(to: @user.email, subject: 'Reset your password') do |format|
      format.html { render layout: 'basic_mailer' }
    end
  end
end
