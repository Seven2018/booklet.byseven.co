# frozen_string_literal: true

class CampaignDraft::DatesController < CampaignDraft::BaseController
  def update
    campaign_draft.update campaign_draft_params
    if current_params_persisted?
      campaign_draft.dates_set!
      redirect_to edit_campaign_draft_launches_path
    else
      flash[:alert] = validation_error_flash_message
      redirect_to edit_campaign_draft_dates_path
    end
  end

  private

  def campaign_draft_params_keys
    %i[date]
  end

  def previous_steps_params_keys
    %i[
      title kind
      interviewee_selection_method
      interviewer_selection_method
      default_interviewer_id
      interviewee_ids
      templates_selection_method default_template_id
    ]
  end
end
