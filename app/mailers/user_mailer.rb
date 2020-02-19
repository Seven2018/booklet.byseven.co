class UserMailer < ApplicationMailer
  default from: Rails.application.credentials.gmail_username

  def account_created(user)
    @host = Current.user
    @user = user
    mail(to: @user.email, subject: 'Booklet: Your account has been created !')
  end

  def invite_email(user, attendee)
    @host = Current.user
    @user = user
    @attendee = attendee
    @training = Training.joins(training_workshops: :attendees).where(attendees: {id: @attendee.id}).first unless @attendee.training_workshop.training.nil?
    mail(to: @user.email, subject: 'Booklet: New invitation')
  end
end
