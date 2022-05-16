class Objective::ElementsController < ApplicationController
  before_action :show_navbar_objective
  before_action :set_objective_element, only: [:show, :update]

  skip_forgery_protection

  skip_after_action :verify_authorized, only: [
    :archive, :destroy, :my_objectives, :my_team_objectives, :my_team_objectives_current_list, :my_team_objectives_archived_list
  ]

  def index
    policy_scope(Objective::Element)
  end

  def list
    @users = User.where(company: current_user.company)
    authorize @users

    # render json: @users, include: ['objective_elements.objective_indicator']
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

      objective = Objective::Element.new(objective_params.merge(objectivable: user, creator: current_user))
      objective.company = user.company
      authorize objective

      if objective.save
        options = params.dig(:indicator, :options)
        current_value =
          if ['boolean', 'numeric_value', 'percentage'].include? params.dig(:indicator, :indicator_type)
            options[:starting_value]
          else
            ''
          end

        indicator = Objective::Indicator.create(objective_element: objective,
                                                indicator_type: params.dig(:indicator, :indicator_type),
                                                options: params.dig(:indicator, :options).merge(current_value: current_value))
      end

    end

    redirect_to objective_elements_path
  end

  def show
    authorize @objective

    set_logs
    @objective = @objective.decorate
  end

  def update
    authorize @objective

    @objective.assign_attributes(objective_params)
    changed_attributes = @objective.changed_attributes

    if changed_attributes && @objective.save

      changed_attributes.each do |k, v|
        log_params = {title: "#{k.capitalize} updated",
                    owner: current_user,
                    log_type: "#{k}_updated",
                    initial_value: v,
                    updated_value: objective_params[k],
                    objective_element_id: @objective.id
                   }

        Objective::Log.create(log_params)
      end

    end

    set_logs
    @objective = @objective.decorate

    respond_to do |format|
      format.js
    end
  end

  def my_objectives
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

  def set_logs
    @logs = @objective.objective_logs.order(created_at: :desc)
  end

  def set_objective_element
    @objective = Objective::Element.find(params[:id])
  end

  def objective_params
    params.require(:objective_element).permit(:title, :description, :due_date)
  end
end
