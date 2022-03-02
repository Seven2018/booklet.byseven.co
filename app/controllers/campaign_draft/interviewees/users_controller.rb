# frozen_string_literal: true

class CampaignDraft::Interviewees::UsersController < CampaignDraft::BaseController
  def index
    render partial: 'campaign_draft/participants/users', locals: { users: users }
  end

  def create
    @campaign.update interviewee_ids: interviewee_ids
  end

  private

  def users
    return current_user.company.users.order(lastname: :asc) if params[:search].blank?

    User.where(company: current_user.company).search_users(params[:search])
  end
end
