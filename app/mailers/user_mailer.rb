class UserMailer < ApplicationMailer
  default from: CompanyInfo.no_reply

  def account_created(user, token)
    @host = Current.user
    @user = user
    @token = token
    mail(to: @user.email, subject: 'Welcome to Booklet !')
  end

  def invite_email(user, attendee)
    @host = Current.user
    @user = user
    @attendee = attendee
    mail(to: @user.email, subject: 'Booklet: New invitation')
  end
end
