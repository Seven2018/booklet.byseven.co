# frozen_string_literal: true

class CampaignDraft::TemplatesController < CampaignDraft::BaseController

  def update
    multi_templates_ids =
      params[:multi_templates_ids].nil? ? [] : params[:multi_templates_ids].permit!.to_hash.to_string.split(',')
    campaign_draft.update campaign_draft_params.merge(multi_templates_ids: multi_templates_ids)

    if current_params_persisted?
      campaign_draft.templates_set!
      redirect_to edit_campaign_draft_dates_path
    else
      flash[:alert] = validation_error_flash_message
      redirect_to edit_campaign_draft_participants_path
    end
  end

  private

  def campaign_draft_params_keys
    %i[templates_selection_method default_template_id]
  end

  def previous_steps_params_keys
    %i[
      title kind
      interviewee_selection_method
      interviewer_selection_method
      default_interviewer_id
      interviewee_ids
    ]
  end
end
