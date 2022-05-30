class TrainingMailer < ApplicationMailer
  default from: CompanyInfo.no_reply
  layout 'notification_mailer'

  def invite_attendee(attendee, training)
    @attendee = attendee
    @training = training
    @icon = '🏋️'
    @title = 'Training time !'
    @description = "You have been invited to the training #{@training.title} !\n Let's review the details."
    @button_text = "Go to My Trainings"
    @button_link = my_trainings_url

    mail(to: @attendee.email, subject: "New training booked for you !")
  end

  def training_reminder(attendee, training)
    @attendee = attendee
    @training = training
    @icon = '🏁'
    @title = 'Here is a reminder for you !'
    @description = "It seems you have not validated all the workshops in the training #{@training.title},\n don't forget to do it !"
    @button_text = "Go to the training"
    @button_link = training_url(@training)

    mail(to: @attendee.email, subject: "Don't forget your training !")
  end

  def session_reminder(attendee, session, eta)
    @attendee = attendee
    @session = session
    @eta = eta
    @email_object = @eta > 0 ? "Next training in #{@eta} days" : "D-Day !"
    @icon = '🕖'
    @title = @email_object

    if @eta > 0
      @description = "A training session will take place on #{@session.date.strftime('%d %B %Y')}\n from #{@session.starts_at.strftime('%H:%M')} to #{@session.ends_at.strftime('%H:%M')}"
    else
      @description = "Don't forget today's training session from #{@session.starts_at.strftime('%H:%M')} to #{@session.ends_at.strftime('%H:%M')}"
    end
    @button_text = "Go to my trainings"
    @button_link = my_trainings_url


    mail(to: @attendee.email, subject: "#{@email_object}")
  end
end
