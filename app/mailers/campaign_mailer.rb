class CampaignMailer < ApplicationMailer
  default from: CompanyInfo.no_reply
  layout 'notification_mailer'

  def invite_employee(interviewer, interviewee, interview)
    interview_email_settings(interviewer, interviewee, interview)
    @icon = 'noto_person-running.png'
    @title = '3,2,1 Start !'
    @description = "The campaign #{@interview.campaign.title} has just begun !\n #{@interviewer.firstname} #{@interviewer.lastname} invites you to complete your interview."
    @button_text = "Go to My Interviews"
    @button_link = my_interviews_url

    mail(to: @interviewee.email, subject: "You are invited to the campaign '#{@interview.campaign.title}' !")
  end

  def invite_interviewer(interviewer, interviewees_count, campaign)
    @interviewer = interviewer
    @interviewees_count = interviewees_count
    @campaign = campaign
    @icon = 'noto_person-running.png'
    @title = '3,2,1 Start !'
    @description = "The campaign #{@campaign.title} has just begun !\n You have #{@interviewees_count} interviewees to manage for this campaign."
    @button_text = "Go to My Team Interviews"
    @button_link = my_team_interviews_url

    mail(to: @interviewer.email, subject: "You are now interviewer for the campaign '#{@campaign.title}' !")
  end

  def interview_reminder(interviewer, interviewee, interview)
    interview_email_settings(interviewer, interviewee, interview)
    @icon = 'noto-v1_bell.png'
    @title = 'Here is a reminder for you !'
    @description = "#{@interviewer.firstname} needs you to complete your interview #{@interview.campaign.title}."
    @button_text = "Go to my review"
    @button_link = interview_url(@interview)

    mail(to: @interviewee.email, subject: "Don't forget your interview !")
  end

  def interview_reminder_time(interviewer, interviewee, interview, time_remaining)
    interview_email_settings(interviewer, interviewee, interview)
    @time_remaining = time_remaining
    @days_left = @time_remaining > 0 ? (@time_remaining.to_s + " days left") : "Last day"
    @icon = 'noto-v1_eleven-oclock.png'
    @title = @time_remaining > 0 ? "Only #{@time_remaining} days left !" : "Last day of the campaign"
    @description = "You have yet to submit your answers for the campaign #{@interview.campaign.title},\n don't forget to do it !"
    @button_text = "Go to my review"
    @button_link = interview_url(@interview)

    mail(to: @interviewee.email, subject: "#{@days_left} to complete your interview !")
  end

  def interview_set_completed_interviewee(interviewer, interviewee, interview)
    interview_email_settings(interviewer, interviewee, interview)
    @icon = 'noto_chequered-flag.png'
    @title = "Interview completed !"
    @description = "Your interview in the '#{@interview.campaign.title}' campaign is completed !\n You may still access your answers :"
    @button_text = "See my answers"
    @button_link = interview_url(@interview)

    mail(to: @interviewee.email, subject: "Congratulation, ‘#{@interview.campaign.title}’ is completed !")
  end

  def interview_set_completed_interviewer(interviewer, interviewee, interview)
    interview_email_settings(interviewer, interviewee, interview)
    @icon = 'noto_raising-hands.png'
    @title = "Interviews Completed with #{@interviewee.fullname} !"
    @description = "You have finished the interview process with #{@interviewee.fullname}\n for the '#{@interview.campaign.title}' campaign !\n You may still access the interview(s)"
    @button_text = "See interviews"
    @button_link = campaign_url(@interview.campaign)

    mail(to: @interviewer.email, subject: "Interviews completed with #{@interviewee.fullname} !")
  end

  def campaign_completed(interviewer, campaign)
    @interviewer = interviewer
    @campaign = campaign
    @icon = 'noto_chequered-flag.png'
    @title = "Campaign completed, nice work !"
    @description = "Your have just completed all your interviews in the '#{@campaign.title}' campaign !\n You may have other ongoing campaigns"
    @button_text = "See my campaigns"
    @button_link = my_team_interviews_url

    mail(to: @interviewer.email, subject: "Campaign completed !")
  end

  private

  def interview_email_settings(interviewer, interviewee, interview)
    @interviewee = interviewee
    @interviewer = interviewer
    @interview = interview
    # @url = new_user_session_url + "?user_email=#{interviewee.email.gsub("@", "%40")}&user_token=#{interviewee.authentication_token}&redirect_to=interviews/#{interview.id}"
  end
end
