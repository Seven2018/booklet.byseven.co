# frozen_string_literal: true

class Objective::UsersController < ApplicationController
  before_action :show_navbar_objective

  skip_after_action :verify_authorized, only: [
    :my_team_objectives, :my_team_objectives_current_list, :my_team_objectives_archived_list
  ]

  def index
    render partial: 'objective/elements/new/users', locals: { users: users, selected: params.dig(:selected) }
  end

  def show
  end

  def info
    user = User.find(params[:id])
    skip_authorization

    render json: user
  end

  def list_current
    user = User.find(params[:id])
    skip_authorization

    objectives_current = user
                           .objective_elements
                           .where(status: :opened)

    render json: objectives_current
  end

  def list_archived
    user = User.find(params[:id])
    skip_authorization

    objectives_archived = user
                            .objective_elements
                            .where(status: :archived)

    render json: objectives_archived
  end

  def my_team_objectives
    @user = User.find(params[:id])
    authorize @user, policy_class: Objective::UserPolicy
  end

  # TODO: check url
  def my_team_objectives_current_list
    @user = User.find(params[:id])
    employees = @user.employees.joins(:objective_elements).where(objective_elements: { status: :opened }).distinct

    render json: employees, include: ['objective_elements.objective_indicator']
  end

  def my_team_objectives_archived_list
    @user = User.find(params[:id])
    employees = @user.employees.joins(:objective_elements).where(objective_elements: { status: :archived }).distinct

    render json: employees, include: ['objective_elements.objective_indicator']
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
