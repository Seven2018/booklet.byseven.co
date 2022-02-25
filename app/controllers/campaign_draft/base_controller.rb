# frozen_string_literal: true

class CampaignDraft::BaseController < ApplicationController
  before_action :show_navbar_campaign
  before_action :set_multi_step_form_navbar_content, :authorize_campaign_draft

  def edit
    render template: "campaign_draft/edit"
  end

  private

  def all_params_persisted?
    campaign_draft_params.keys.all?{ |param| campaign_draft.send(param.to_sym).present? }
  end

  def set_multi_step_form_navbar_content
    @multi_step_form_navbar_content = campaign_draft.title
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
end
