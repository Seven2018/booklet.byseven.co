# frozen_string_literal: true

class CampaignDraft::DatesController < CampaignDraft::BaseController
  def update
    campaign_draft.update campaign_draft_params
    if all_params_persisted?
      campaign_draft.dates_set!
      redirect_to edit_campaign_draft_launches_path
    else
      flash[:alert] = "TODO problem !"
      redirect_to edit_campaign_draft_dates_path
    end
  end

  private

  def campaign_draft_params
    params.permit(:date)
  end
end
