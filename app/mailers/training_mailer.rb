class TrainingMailer < ApplicationMailer
  default from: CompanyInfo.no_reply

  def invite_attendee(attendee, training)
    @attendee = attendee
    @training = training
    mail(to: @attendee.email, subject: "New training booked for you !")
  end

  def training_reminder(attendee, training)
    @attendee = attendee
    @training = training
    mail(to: @attendee.email, subject: "Don't forget your training !")
  end
end
