class Campaigns::InterviewSetsController < Campaigns::BaseController
  def create
    raise Pundit::NotAuthorizedError unless
      CampaignPolicy.new(current_user, campaign).add_interview_set?

    params_set = interview_params
    @status = InterviewSets::Create.call(params_set).present?

    respond_to do |format|
      format.html { redirect_to campaign_path(@campaign) }
      format.js {
        @campaign = campaign.decorate
        @employees = campaign.employees.order(lastname: :asc).uniq
      }
    end
  end

  def destroy
    raise Pundit::NotAuthorizedError unless
      CampaignPolicy.new(current_user, campaign).remove_interview_set?

    campaign.interviews.where(employee_id: params[:user_id]).destroy_all
    campaign.destroy if @campaign.interviews.empty?

    head :ok
  end

  private

  def interview_params
    {
      employee: employee,
      interviewer: interviewer,
      interview_form: interview_form,
      title: campaign.title,
      creator: campaign.owner,
      campaign: campaign
    }
  end

  def interview_form
    campaign_templates = campaign.interview_forms_list

    user_tag = UserTag.find_by(user_id: params.dig(:interview_set, :user_id), tag_id: campaign_templates.keys)

    interview_form = InterviewForm.find_by(id: (campaign_templates[(user_tag&.tag_id&.to_s.presence || 'default_template')]))
  end

  def employee
    User.find(params.dig(:interview_set, :user_id))
  end

  def interviewer
    User.find_by(id: params.dig(:interview_set, :interviewer_id))
  end
end
