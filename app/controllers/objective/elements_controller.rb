class Objective::ElementsController < ApplicationController
  before_action :show_navbar_objective

  skip_forgery_protection

  skip_after_action :verify_authorized, only: [:archive, :destroy]

  def index
    policy_scope(Objective::Element)
  end

  def list
    @users = User.where(company: current_user.company)
    authorize @users

    render json: @users
  end

  def new
    @objective = Objective::Element.new
    authorize @objective
  end

  def create
    user_ids = params.dig(:selected_users_ids).split(',')

    user_ids.each do |user_id|

      user = User.find(user_id)

      objective = Objective::Element.new(objective_params.merge(objectivable: user))
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

  def my_objectives
    @objectives = Objective::Element.all
    authorize @objectives
  end

  def my_team_objectives
    @objectives = Objective::Element.all
    authorize @objectives
  end

  def archive
    objective = Objective::Element.find(params[:id])

    if objective.update(status: :archived)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
    objective = Objective::Element.find(params[:id])
    model = objective.destroy

    if model.valid?
      head :ok
    else
      render json: model.errors.messages
    end
  end

  private

  def objective_params
    params.require(:objective_element).permit(:title, :description, :due_date)
  end
end
