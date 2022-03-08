# frozen_string_literal: true

class TrainingDraft::BaseController < ApplicationController
  before_action :show_navbar_training
  before_action :set_multi_step_form_navbar_content, :authorize_training_draft
  before_action :previous_steps_completed, only: :edit

  def edit
    render template: "training_draft/edit"
  end

  private

  def previous_steps_completed
    unless previous_params_persisted?
      flash[:alert] = "Please complete each step !"
      redirect_back(fallback_location: edit_training_draft_participants_path) and return
    end
  end

  def previous_params_persisted?
    previous_steps_params_keys.all?{ |param| training_draft.send(param.to_sym).present? }
  end

  def training_draft_params
    params.permit training_draft_params_keys
  end

  def training_draft_params_first_level_keys
    training_draft_params_keys.map do |param|
      method = param.is_a?(Enumerable) ? param.keys.first.to_sym : param.to_sym
    end
  end

  def validation_error_flash_message
    "Please fill out all required fields: \
    #{training_draft_params_first_level_keys.map{|x| x.to_s.humanize}.join(', ')}"
  end

  def current_params_persisted?
    training_draft_params_first_level_keys.all? { |param| training_draft.send(param).present? }
  end

  def set_multi_step_form_navbar_content
    @multi_step_form_navbar_content = training_draft.content&.title.presence || 'New training'
  end

  def skip_pundit?
    true
  end

  def authorize_training_draft
    raise Pundit::NotAuthorizedError unless
      # CampaignPolicy.new(current_user, Campaign.new).create? &&
      InterviewPolicy.new(current_user, Training.new).create?
  end

  def training_draft
    @training ||= current_user.training_draft.decorate
  end

  def participant_ids
    return current_user.company.users.ids if params[:participant_ids] == 'all'

    params[:participant_ids].split(',').uniq.select(&:present?)
  end
end
