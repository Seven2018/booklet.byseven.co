class UserMailer < ApplicationMailer
  default from: CompanyInfo.no_reply

  def account_created(user)
    @user = user
    @token = user.invitation_token
    mail(to: @user.email, subject: 'Welcome to Booklet !')
  end
end
