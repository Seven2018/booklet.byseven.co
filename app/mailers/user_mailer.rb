class UserMailer < ApplicationMailer
  default from: Rails.application.credentials.gmail_username

  def invite_email(user, attendee)
    @user = user
    @attendee = attendee
    @training = Training.joins(training_workshops: :attendees).where(attendees: {id: @attendee.id}).first unless @attendee.training_workshop.training.nil?
    mail(to: @user.email, subject: 'Booklet: New invitation')
  end
end
