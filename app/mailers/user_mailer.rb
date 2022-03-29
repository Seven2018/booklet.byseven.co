class UserMailer < ApplicationMailer
  default from: CompanyInfo.no_reply

  def account_created(user, token)
    @host = Current.user
    @user = user
    @token = token
    mail(to: @user.email, subject: 'Welcome to Booklet !')
  end
end
