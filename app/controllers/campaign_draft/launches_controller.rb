# frozen_string_literal: true

class CampaignDraft::LaunchesController < CampaignDraft::BaseController
  def update
    new_campaign = CampaignDrafts::Campaigns::Launch.call(campaign_draft: campaign_draft)
    if new_campaign.present?
      @campaign.launches_set!
      redirect_to campaign_path(new_campaign) and return
    else
      flash[:alert] = "TODO problem !"
      redirect_to edit_campaign_draft_launches_path
    end
  end
end
