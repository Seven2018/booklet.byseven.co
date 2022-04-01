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

  def session_reminder(attendee, session, eta)
    @attendee = attendee
    @session = session
    @eta = eta
    @email_object = @eta > 0 ? "Next training in #{@eta} days" : "D-Day !"
    mail(to: @attendee.email, subject: "#{@email_object}")
  end
end
