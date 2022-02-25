# frozen_string_literal: true

class CampaignDraft::SettingsController < CampaignDraft::BaseController
  def update
    campaign_draft.update campaign_draft_params
    if all_params_persisted?
      campaign_draft.settings_set!
      redirect_to edit_campaign_draft_participants_path
    else
      flash[:alert] = "TODO problem !"
      redirect_to edit_campaign_draft_settings_path
    end
  end

  private

  def campaign_draft_params
    params.permit(:title, :kind)
  end

  def set_multi_step_form_navbar_content
    @multi_step_form_navbar_content = campaign_draft.title.presence || 'New Campaign'
  end
end
