# frozen_string_literal: true

class CampaignDraft::LaunchesController < CampaignDraft::BaseController
  def update
    campaign_draft.update(send_invitation: params[:send_email] == 'true')

    new_campaign = CampaignDrafts::Campaigns::Launch.call(campaign_draft: campaign_draft)

    if new_campaign&.id.present?
      campaign_draft.launches_set!

      new_campaign.update(interview_forms_list: campaign_draft.multi_templates_ids.join(',').to_h
                                                              .merge('default_template' => campaign_draft.default_template_id.to_s),
                          calendar_uuid: SecureRandom.hex(32))

      redirect_to campaigns_path

    else
      flash[:alert] = validation_error_flash_message
      redirect_to edit_campaign_draft_settings_path
    end
  end

  private

  def campaign_draft_params_keys
    previous_steps_params_keys
  end

  def previous_steps_params_keys
    %i[
      title kind
      interviewee_selection_method
      interviewer_selection_method
      default_interviewer_id
      interviewee_ids
      templates_selection_method default_template_id
      date
    ]
  end
end
