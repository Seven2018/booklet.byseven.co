# frozen_string_literal: true

class CampaignDraft::LaunchesController < CampaignDraft::BaseController
  def update
    new_campaign = CampaignDrafts::Campaigns::Launch.call(campaign_draft: campaign_draft)
    if new_campaign.present?
      @campaign.launches_set!
      if params[:send_email] == 'true'
        interviewers = new_campaign.interviewers.uniq
        interviewees = new_campaign.employees.uniq

        interviewers.each do |interviewer|
          CampaignMailer.with(user: interviewer)
            .invite_interviewer(interviewer, interviewees.count, new_campaign)
            .deliver_now
        end

        interviewees.each do |interviewee|
          interview = Interview.find_by(campaign: new_campaign, employee: interviewee, label: 'Employee')
          interviewer = interview.interviewer

          CampaignMailer.with(user: interviewee)
            .invite_employee(interviewer, interviewee, interview)
            .deliver_now
        end
      end
      redirect_to campaign_path(new_campaign)
    else
      flash[:alert] = validation_error_flash_message
      redirect_to edit_campaign_draft_launches_path
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
