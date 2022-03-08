# frozen_string_literal: true

class CampaignDraft::SettingsController < CampaignDraft::BaseController
  def update
    campaign_draft.update campaign_draft_params
    if current_params_persisted?
      campaign_draft.settings_set!
      redirect_to edit_campaign_draft_participants_path
    else
      flash[:alert] = validation_error_flash_message
      redirect_to edit_campaign_draft_settings_path
    end
  end

  private

  def campaign_draft_params_keys
    %i[title kind]
  end

  def previous_steps_params_keys
    %i[]
  end
end
