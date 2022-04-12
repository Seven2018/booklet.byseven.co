class UserMailer < ApplicationMailer
  default from: CompanyInfo.no_reply
  layout 'notification_mailer'

  def account_created(user)
    @user = user
    @token = user.invitation_token
    @icon = 'noto_waving-hand.png'
    @title = "Hello, #{@user.fullname}"
    @description = "Your have been invited to join Booklet !\n Click here to create your password"
    @button_text = "Create my password"
    @button_link = accept_invitation_url(@user, invitation_token: @token)

    mail(to: @user.email, subject: 'Welcome to Booklet !')
  end
end
