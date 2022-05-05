# frozen_string_literal: true

class Objective::UsersController < CampaignDraft::BaseController

  def index
    render partial: 'campaign_draft/participants/users', locals: { users: users }
  end

  private

  def users
    return current_user.company.users.order(lastname: :asc) if params[:search].blank?


    if current_user.access_level_int.to_sym != :manager
      User.where(company: current_user.company, manager_id: current_user.id).search_users(params[:search])
    else
      User.where(company: current_user.company).search_users(params[:search])
    end
  end
end
