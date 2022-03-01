# frozen_string_literal: true

class CampaignDraft::Search::UsersController < CampaignDraft::BaseController
  def index
    render partial: 'campaign_draft/partials/campaign_draft_users_list', locals: {
      users: users.page(1),
      total_users_count: users.count, # to update
      page: 1
    }
  end

  private

  def users
    return current_user.company.users.order(lastname: :asc) if params[:search].blank?

    User.where(company: current_user.company).search_users(params[:search])
  end
end
