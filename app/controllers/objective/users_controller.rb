# frozen_string_literal: true

class Objective::UsersController < CampaignDraft::BaseController

  def index
    render partial: 'objective/elements/new/users', locals: { users: users, selected: params.dig(:selected) }
  end

  private

  def users
    company_users = current_user.company.users.order(lastname: :asc)

    if current_user.access_level_int.to_sym == :manager
      manager_users = company_users.where(manager_id: current_user.id)
      params[:search].blank? ? manager_users : manager_users.search_users(params[:search])
    else
      params[:search].blank? ? company_users : company_users.search_users(params[:search])
    end
  end
end
