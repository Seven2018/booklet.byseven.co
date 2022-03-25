class TrainingMailer < ApplicationMailer
  default from: CompanyInfo.no_reply

  def invite_attendee(attendee, training)
    @attendee = attendees
    @training = training
    mail(to: User.first.email, subject: "New training booked for you !")
    # mail(to: @interviewee.email, subject: "#{@interviewee.company.name} - Interview")
  end

  def training_reminder(attendee, training)
    @attendee = attendees
    @training = training
    mail(to: User.first.email, subject: "Don't forget your training !")
    # mail(to: @interviewee.email, subject: "#{@interviewee.company.name} - Interview")
  end
end
