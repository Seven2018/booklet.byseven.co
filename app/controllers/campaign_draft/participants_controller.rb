# frozen_string_literal: true

class CampaignDraft::ParticipantsController < CampaignDraft::BaseController
  def update
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

  def campaign_draft_params
    params.permit(:interviewee_selection_method, :interviewer_selection_method,
      :default_interviewer_id, interviewee_ids: [])
  end
end
