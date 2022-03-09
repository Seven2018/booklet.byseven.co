class Campaigns::InterviewSetsController < Campaigns::BaseController
  skip_after_action :verify_authorized

  def create
    @status = InterviewSets::Create.call(interview_params).present?
    respond_to do |format|
      format.html {redirect_to campaign_path(@campaign)}
      format.js
    end
  end

  private

  def last_campaign_interview
    @last_campaign_interview ||= campaign.interviews.order(date: :desc).first
  end

  def interview_params
    {
      employee: employee,
      interviewer: (employee.manager.presence || campaign.owner),
      interview_form: last_campaign_interview.interview_form,
      title: campaign.title,
      date: last_campaign_interview.date,
      starts_at: last_campaign_interview.starts_at,
      ends_at: last_campaign_interview.ends_at,
      creator: campaign.owner,
      campaign: campaign
    }
  end

  def employee
    @user ||= User.find params[:user_id]
  end
end