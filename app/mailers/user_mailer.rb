class UserMailer < ApplicationMailer
  default from: Rails.application.credentials.gmail_username

  def account_created(user, token)
    @host = Current.user
    @user = user
    @token = token
    mail(to: @user.email, subject: 'Booklet: Your account has been created !')
  end

  def invite_email(user, attendee)
    @host = Current.user
    @user = user
    @attendee = attendee
    mail(to: @user.email, subject: 'Booklet: New invitation')
  end
end
