class Objective::IndicatorsController < ApplicationController

  def update
    @indicator = Objective::Indicator.find(params[:id])
    authorize @indicator

    options = @indicator.options
    initial_value = options["current_value"]

    log_params = {title: 'Completion updated',
                  comments: params.dig(:objective_log, :comments),
                  owner: current_user,
                  initial_value: options['current_value'],
                  objective_element_id: @indicator.objective_element.id,
                  objective_indicator_id: @indicator.id
                 }

    if @indicator.multi_choice?
      options['current_value'] = options[params[:selected_option]] if params[:selected_option].present?

      log_params.merge!(updated_value: options[params[:selected_option]])

      @indicator.update options: options if options['current_value'] != initial_value
    end

    Objective::Log.create(log_params) if options['current_value'] != initial_value

    respond_to do |format|
      format.js
    end
  end

end
