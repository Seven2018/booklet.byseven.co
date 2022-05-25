class Objective::IndicatorsController < ApplicationController

  def update
    @indicator = Objective::Indicator.find(params[:id])
    @objective = @indicator.objective_element
    authorize @indicator

    options = @indicator.options
    initial_value = options["current_value"]

    log_params = {title: 'Completion updated',
                  comments: params.dig(:objective_log, :comments),
                  owner: current_user,
                  log_type: :value_updated,
                  initial_value: options['current_value'],
                  objective_element_id: @objective.id,
                  objective_indicator_id: @indicator.id
                 }

    options['current_value'] =
      if @indicator.boolean?
        params[:indicator_checked].present? ? options['target_value'] : options['starting_value']
      elsif @indicator.numeric_value? || @indicator.percentage?
        params[:chosen_value]
      elsif @indicator.multi_choice?
        options[params[:selected_option]] if params[:selected_option].present?
      end

    log_params.merge!(updated_value: options[params[:selected_option]])

    @indicator.update options: options if options['current_value'] != initial_value
    @objective = @objective.decorate

    Objective::Log.create(log_params.merge(updated_value: options['current_value'])) if options['current_value'] != initial_value

    @logs = @indicator.objective_element.objective_logs.order(created_at: :desc)

    respond_to do |format|
      format.js
    end
  end

end
