# frozen_string_literal: true

class Objective::UsersController < ApplicationController
  before_action :show_navbar_objective

  def index
    render partial: 'objective/elements/new/users', locals: { users: users, selected: params.dig(:selected) }
  end

  def show
  end

  def info
    user = User.find(params[:id])

    render json: user
  end

  def list_current
    user = User.find(params[:id])
    objectives_current = user
                           .objective_elements
                           .where(status: :opened)

    render json: objectives_current
  end

  def list_archived
    user = User.find(params[:id])
    objectives_archived = user
                            .objective_elements
                            .where(status: :archived)

    render json: objectives_archived
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

  def skip_pundit?
    true
  end
end