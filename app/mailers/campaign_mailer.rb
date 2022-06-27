class CampaignMailer < ApplicationMailer
  default from: CompanyInfo.no_reply
  layout 'basic_mailer'

  def invite_employee(interviewer, interviewee, interview)
    interviewee_email_settings(interviewer, interviewee, interview)
    @icon = '🏃'
    @title = '3,2,1 Start !'
    @description = "The campaign #{@campaign.title} has just begun !\n #{@interviewer.firstname} #{@interviewer.lastname} invites you to complete your interview."
    @button_text = "Go to my interview"
    @button_link = interview_url(@interview)

    campaign_calendar_link(@campaign, @interviewee)

    @nb = "Please don't answer this email."

    mail(to: @interviewee.email, subject: "You are invited to the campaign '#{@campaign.title}' !")
  end

  def invite_interviewer(interviewer, campaign)
    interviewer_email_settings(interviewer, campaign)

    @icon = '🏃'
    @title = '3,2,1 Start !'
    @description = "The campaign #{@campaign.title} has just begun !\n"
    @button_text = "Go to the campaign"
    @button_link = campaign_url(@campaign)

    campaign_calendar_link(@campaign, @interviewer)

    @nb = "Please don't answer this email."

    mail(to: @interviewer.email, subject: "You are now interviewer for the campaign '#{@campaign.title}' !")
  end

  def interview_reminder(interviewer, interviewee, interview)
    interviewee_email_settings(interviewer, interviewee, interview)
    @icon = '⏰'
    @title = 'Here is a reminder for you !'
    @description = "Don’t forget to complete your interview in the campaign #{@campaign.title}."
    @button_text = "Go to my interview"
    @button_link = interview_url(@interview)

    campaign_calendar_link(@campaign, @interviewee)

    @nb = "Please don't answer this email."

    mail(to: @interviewee.email, subject: "⏰ Here is a reminder for you ! ⏰")
  end

  def campaign_interviewer_reminder(interviewer, campaign)
    interviewer_email_settings(interviewer, campaign)

    label = { 'Employee' => 'Interviewee', 'Manager' => 'Interviewer', 'Crossed' => 'Cross review' }

    @icon = '⏰'
    @title = 'Here is a reminder for you !'
    @description = "Don’t forget to complete the campaign #{@campaign.title}. \n Interviews left to do : \n\n"

    @campaign.employees_for(interviewer.id).each do |employee|

      @description += "#{employee.fullname}\n"
      interviews = @campaign.interviews_for(employee.id)

      interviews.each do |interview|
        @description += "- #{label[interview.label]}\n" unless interview.submitted?
      end

    end

    @button_text = "Go to the campaign"
    @button_link = campaign_url(@campaign)

    campaign_calendar_link(@campaign, @interviewer)

    @nb = "Please don't answer this email."

    mail(to: @interviewer.email, subject: "⏰ Here is a reminder for you ! ⏰")
  end

  def interview_reminder_time(interviewer, interviewee, interview, time_remaining)
    interviewee_email_settings(interviewer, interviewee, interview)
    @time_remaining = time_remaining
    @days_left = @time_remaining > 0 ? (@time_remaining.to_s + " days left") : "Last day"
    @icon = '🕖'
    @title = @time_remaining > 0 ? "Only #{@time_remaining} days left !" : "Last day of the campaign"
    @description = "You have yet to submit your answers for the campaign #{@campaign.title},\n don't forget to do it !"
    @button_text = "Go to my review"
    @button_link = interview_url(@interview)

    @nb = "Please don't answer this email."

    mail(to: @interviewee.email, subject: "#{@days_left} to complete your interview !")
  end

  def interview_set_completed_interviewee(interviewer, interviewee, interview)
    interviewee_email_settings(interviewer, interviewee, interview)
    @icon = '🏁'
    @title = "Interview completed !"
    @description = "Your interview in the '#{@campaign.title}' campaign is completed !\n You may still access your answers :"
    @button_text = "See my answers"
    @button_link = interview_url(@interview)

    @nb = "Please don't answer this email."

    mail(to: @interviewee.email, subject: "Congratulation, ‘#{@campaign.title}’ is completed !")
  end

  def interview_set_completed_interviewer(interviewer, interviewee, interview)
    interviewee_email_settings(interviewer, interviewee, interview)
    @icon = '🙌'
    @title = "Interviews Completed with #{@interviewee.fullname} !"
    @description = "You have finished the interview process with #{@interviewee.fullname}\n for the '#{@campaign.title}' campaign !\n You may still access the interview(s)"
    @button_text = "See interviews"
    @button_link = campaign_url(@campaign)

    @nb = "Please don't answer this email."

    mail(to: @interviewer.email, subject: "Interviews completed with #{@interviewee.fullname} !")
  end

  def campaign_completed(interviewer, campaign)
    @interviewer = interviewer
    @campaign = campaign
    @icon = '🏁'
    @title = "Campaign completed, nice work !"
    @description = "Your have just completed all your interviews in the '#{@campaign.title}' campaign !\n You may have other ongoing campaigns"
    @button_text = "See my campaigns"
    @button_link = my_team_interviews_url

    @nb = "Please don't answer this email."

    mail(to: @interviewer.email, subject: "Campaign completed !")
  end

  def campaign_interview_created(owner, campaign)
    @owner = owner
    @campaign = campaign
    @icon = '🚀'
    @title = "Your campaign #{campaign.title} has been launched !"
    @description = "All interviewers and interviewees can now acces their interviews in the campaign “#{campaign.title}”."
    @button_text = "Go to campaign index"
    @button_link = campaigns_url

    @nb = "Please don't answer this email."

    mail(to: @owner.email, subject: "Your campaign #{campaign.title} has been launched !")
  end

  private

  def interviewee_email_settings(interviewer, interviewee, interview)
    @interviewee = interviewee
    @interviewer = interviewer
    @interview = interview
    @campaign = interview.campaign.decorate
  end

  def interviewe_email_settings(interviewer, campaign)
    @interviewer = interviewer
    @campaign = interview.campaign.decorate
  end

  def campaign_calendar_link(campaign, user)
    @optional_text = "The deadline for this campaign is set on #{campaign.deadline}"
    @optional_button_text = "Save it to Google Calendar"
    @optional_button_link = redirect_calendar_campaigns_url(instance_id: campaign.id, user_id: user.id, mode: 'campaign')
  end
end
