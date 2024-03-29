class Objective::ElementsController < ApplicationController
  before_action :show_navbar_objective
  before_action :set_objective_element, only: [:show, :update]

  skip_forgery_protection
  skip_after_action :verify_authorized, only: [
    :archive,
    :unarchive,
    :destroy,
    :my_objectives,
    :my_team_objectives,
    :my_team_objectives_current_list,
    :my_team_objectives_archived_list,
    :targets,
    :target_list,
    :employees,
  ]

  def index
    policy_scope(Objective::Element)
  end

  def list
    @users = User.where(company: current_user.company)
    @users = User.where(company: current_user.company).search_users(params[:title]) if params[:title]
    @users = @users.order(lastname: :asc)

    authorize @users

    page = params[:page] && params[:page][:number] ? params[:page][:number] : 1
    size = params[:page] && params[:page][:size] ? params[:page][:size] : SIZE_PAGE_INDEX

    @users = @users.page(page).per(size)

    # render json: @users, include: ['objective_elements.objective_indicator']
    render json: @users, meta: pagination_dict(@users)
  end

  def new
    if params[:objective_template_id].present?
      template = Objective::Template.find(params[:objective_template_id])
      @objective = Objective::Element.new(template.clone.attributes.merge(template: false))
    else
      @objective = Objective::Element.new
    end

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

    # redirect_to (params[:redirect_to_storage].presence || objective_elements_path)
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
        log_params = { title: "#{k.split('_').join(' ').capitalize} updated",
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
      format.json { head :ok }
    end
  end

  def my_objectives
    cancel_cache
  end

  def my_team_objectives
    cancel_cache
  end

  def targets
    cancel_cache
  end

  def target_list
    elements = Objective::Element.where(company: current_user.company)
    elements = elements.where('lower(title) LIKE ?', "%#{params[:title].downcase}%") if params[:title].present?
    elements = elements
                 .joins(:objective_indicator)
                 .where(objective_indicators: { indicator_type: params[:indicator_type] }) if params[:indicator_type].present?
    elements = elements
                 .joins(:objective_indicator)
                 .where(objective_indicators: { status: params[:indicator_status] }) if params[:indicator_status].present?
    elements = elements.where('due_date >= ?', Date.parse(params[:from].to_s)) if params[:from].present?
    elements = elements.where('due_date <= ?', Date.parse(params[:to].to_s)) if params[:to].present?

    page = params[:page] && params[:page][:number] ? params[:page][:number] : 1
    size = params[:page] && params[:page][:size] ? params[:page][:size] : SIZE_PAGE_INDEX

    elements = elements.page(page).per(size)

    render json: elements, meta: pagination_dict(elements)
  end

  def employees
    cancel_cache
  end

  def archive
    objective = Objective::Element.find(params[:id])

    if objective.update(status: :archived) && params[:redirected_from]
      redirect_to params[:redirected_from]
    elsif objective.update(status: :archived)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def unarchive
    objective = Objective::Element.find(params[:id])

    if objective.update(status: :opened)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
    objective = Objective::Element.find(params[:id])
    model = objective.destroy

    if model.valid? && params[:redirected_from]
      redirect_to params[:redirected_from]
    elsif model.valid?
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
    params.require(:objective_element).permit(:title, :description, :due_date, :can_employee_edit, :can_employee_view)
  end
end
