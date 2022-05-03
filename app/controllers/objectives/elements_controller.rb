class Objectives::ElementsController < ApplicationController
  before_action :show_navbar_objective

  def index
    @objectives = policy_scope(Objective::Element).where(company: current_user.company)
  end

  def new

  end

  def my_objectives
    @objectives = Objective::Element.all
    authorize @objectives
  end

  def my_team_objectives
    @objectives = Objective::Element.all
    authorize @objectives
  end
end
