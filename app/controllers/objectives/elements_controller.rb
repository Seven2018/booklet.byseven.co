class Objectives::ElementsController < ApplicationController
  before_action :show_navbar_objective

  def index
    @objectives = policy_scope(Objective::Element).where(company: current_user.company)
  end

  def new
    @objective = Objective::Element.new
    authorize @objective
  end

  def create
    @objective = Objective::Element.new(objective_params)
    authorize @objective
  end

  def my_objectives
    @objectives = Objective::Element.all
    authorize @objectives
  end

  def my_team_objectives
    @objectives = Objective::Element.all
    authorize @objectives
  end

  private

  def objective_params
    params.require(:objective_element).permit(:title, :description, :due_date)
  end
end
