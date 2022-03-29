class CampaignMailer < ApplicationMailer
  default from: CompanyInfo.no_reply

  def invite_employee(interviewer, interviewee, interview)
    interviewee_email_settings(interviewer, interviewee, interview)
    mail(to: @interviewee.email, subject: "You are invited to the campaign '#{@interview.campaign.title}' !")
  end

  def invite_interviewer(interviewer, interviewees_count, campaign)
    @interviewer = interviewer
    @interviewees_count = interviewees_count
    @campaign = campaign
    mail(to: @interviewee.email, subject: "You are now interviewer for the campaign '#{@campaign.title}' !")
  end

  def interview_reminder(interviewer, interviewee, interview)
    interviewee_email_settings(interviewer, interviewee, interview)
    mail(to: @interviewee.email, subject: "Don't forget your interview !")
  end

  def interview_reminder_time(interviewer, interviewee, interview, time_remaining)
    interviewee_email_settings(interviewer, interviewee, interview)
    @time_remaining = time_remaining
    @days_left = @time_remaining > 0 ? (@time_remaining.to_s + "days left") : "last day"
    mail(to: @interviewee.email, subject: "#{@days_left} to complete your interview !")
  end

  private

  def interviewee_email_settings(interviewer, interviewee, interview)
    @interviewee = interviewee
    @interviewer = interviewer
    @interview = interview
    # @url = new_user_session_url + "?user_email=#{interviewee.email.gsub("@", "%40")}&user_token=#{interviewee.authentication_token}&redirect_to=interviews/#{interview.id}"
  end
end
