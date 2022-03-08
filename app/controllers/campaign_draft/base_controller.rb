# frozen_string_literal: true

class CampaignDraft::BaseController < ApplicationController
  before_action :show_navbar_campaign
  before_action :set_multi_step_form_navbar_content, :authorize_campaign_draft
  before_action :previous_steps_completed, only: :edit

  def edit
    render template: "campaign_draft/edit"
  end

  private

  def previous_steps_completed
    unless previous_params_persisted?
      flash[:alert] = "Please complete each step !"
      redirect_back(fallback_location: edit_campaign_draft_settings_path) and return
    end
  end

  def previous_params_persisted?
    previous_steps_params_keys.all?{ |param| campaign_draft.send(param.to_sym).present? }
  end

  def campaign_draft_params
    params.permit campaign_draft_params_keys
  end

  def campaign_draft_params_first_level_keys
    campaign_draft_params_keys.map do |param|
      method = param.is_a?(Enumerable) ? param.keys.first.to_sym : param.to_sym
    end
  end

  def validation_error_flash_message
    "Please fill out all required fields: \
    #{campaign_draft_params_first_level_keys.map{|x| x.to_s.humanize}.join(', ')}"
  end

  def current_params_persisted?
    campaign_draft_params_first_level_keys.all? { |param| campaign_draft.send(param).present? }
  end

  def set_multi_step_form_navbar_content
    @multi_step_form_navbar_content = campaign_draft.title.presence || 'New Campaign'
  end

  def skip_pundit?
    true
  end

  def authorize_campaign_draft
    raise Pundit::NotAuthorizedError unless
      CampaignPolicy.new(current_user, Campaign.new).create? &&
      InterviewPolicy.new(current_user, Interview.new).create?
  end

  def campaign_draft
    @campaign ||= current_user.campaign_draft.decorate
  end

  def interviewee_ids
    return current_user.company.users.ids if params[:participant_ids] == 'all'

    params[:participant_ids].split(',').uniq.select(&:present?)
  end
end
