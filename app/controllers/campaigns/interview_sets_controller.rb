class Campaigns::InterviewSetsController < Campaigns::BaseController
  def create
    # raise Pundit::NotAuthorizedError unless
    #   CampaignPolicy.new(current_user, campaign).add_interview_set?

    # params_set = interview_params
    # params_set[:interviewer] = User.find_by(id: params.dig(:add_to_interviewer_id)) || interview_params[:interviewer]
    # @status = InterviewSets::Create.call(params_set).present?
    # filter_interviewees

    # respond_to do |format|
    #   format.html {redirect_to campaign_path(@campaign)}
    #   format.js
    # end
  end

  def destroy
    raise Pundit::NotAuthorizedError unless
      CampaignPolicy.new(current_user, campaign).remove_interview_set?

    campaign.interviews.where(employee_id: params[:user_id]).destroy_all
    campaign.destroy if @campaign.interviews.empty?

    head :ok
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
      creator: campaign.owner,
      campaign: campaign
    }
  end

  def employee
    @user ||= User.find params[:user_id]
  end
end
