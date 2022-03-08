# frozen_string_literal: true

class TrainingDraft::LaunchesController < TrainingDraft::BaseController
  def update
    new_campaign = CampaignDrafts::Campaigns::Launch.call(campaign_draft: campaign_draft)
    if new_campaign.present?
      @training.launches_set!
      redirect_to campaign_path(new_campaign) and return
    else
      flash[:alert] = validation_error_flash_message
      redirect_to edit_campaign_draft_launches_path
    end
  end

  private

  def training_draft_params_keys
    previous_steps_params_keys
  end

  def previous_steps_params_keys
    %i[participant_ids workshop_id cost_cents_per_employee time_slots]
  end
end
