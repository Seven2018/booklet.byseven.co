# frozen_string_literal: true

class CampaignDraft::ParticipantsController < CampaignDraft::BaseController

  def edit
    @users = current_user.company.users.order(lastname: :asc)
    render template: "campaign_draft/edit"
  end

  def update
    # do sth with interviewee_ids
    campaign_draft.update campaign_draft_params
    if all_params_persisted?
      campaign_draft.participants_set!
      redirect_to edit_campaign_draft_templates_path
    else
      flash[:alert] = "TODO problem !"
      redirect_to edit_campaign_draft_participants_path
    end
  end

  private
  def interviewee_ids
    campaign_draft_params[:interviewee_ids].first.split(',').compact
  end

  def campaign_draft_params
    params.permit(:interviewee_selection_method, :interviewer_selection_method,
      :default_interviewer_id, interviewee_ids: [])
  end
end
