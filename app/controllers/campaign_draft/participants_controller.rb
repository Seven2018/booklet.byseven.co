# frozen_string_literal: true

class CampaignDraft::ParticipantsController < CampaignDraft::BaseController
  before_action :set_draft, only: [:select_all, :unselect_all]
  before_action :set_users, only: [:select_all, :unselect_all]

  def update
    campaign_draft.update campaign_draft_params
    if current_params_persisted?
      campaign_draft.participants_set!
      redirect_to edit_campaign_draft_templates_path
    else
      flash[:alert] = validation_error_flash_message
      redirect_to edit_campaign_draft_participants_path
    end
  end

  def select_all
    users_ids = @users.ids

    data = @draft.data
    data['interviewee_ids'] = users_ids

    @draft.update(data: data, interviewee_ids: users_ids)

    respond_to do |format|
      format.js {}
    end
  end

  def unselect_all
    data = @draft.data
    data['interviewee_ids'] = []

    @draft.update(data: data, interviewee_ids: [])

    respond_to do |format|
      format.js {}
    end
  end

  private

  def set_draft
    @draft = CampaignDraft.find(params[:id])
  end

  def set_users
    @users = User.where(company_id: current_user.company_id)
  end

  def campaign_draft_params_keys
    %i[
      interviewee_selection_method
      interviewer_selection_method
      default_interviewer_id
      interviewee_ids
    ]
  end

  def previous_steps_params_keys
    %i[title kind]
  end
end
