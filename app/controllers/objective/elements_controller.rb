class Objective::ElementsController < ApplicationController
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
    @objective.company = current_user.company
    authorize @objective

    if @objective.save
      @indicator = Objective::Indicator.create(objective_element: @objective,
                                            indicator_type: params.dig(:indicator, :indicator_type),
                                            options: params.dig(:indicator, :options))

      redirect_to objective_elements_path
    else
      raise
    end
  end

  def my_objectivess
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
