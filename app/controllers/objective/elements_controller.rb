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
    # raise
    user_ids = params.dig(:selected_users_ids).split(',')

    user_ids.each do |user_id|

      user = User.find(user_id)

      objective = user.objective_elements.new(objective_params)
      # objective = Objective::Element.new(objective_params)
      objective.company = user.company
      authorize objective

      if objective.save
        indicator = Objective::Indicator.create(objective_element: objective,
                                              indicator_type: params.dig(:indicator, :indicator_type),
                                              options: params.dig(:indicator, :options))
      end

    end

    redirect_to objective_elements_path
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
