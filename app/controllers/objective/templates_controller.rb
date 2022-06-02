class Objective::TemplatesController < ApplicationController
  before_action :show_navbar_objective

  skip_forgery_protection
  skip_after_action :verify_policy_scoped
  skip_after_action :verify_authorized

  def index
  end

  def new
  end

  def create
    template = Objective::Template.create(
      title: params.dig(:title),
      description: params.dig(:description),
      company: current_user.company,
      creator: current_user
    )

    if template.valid?
      indicator = template.create_objective_indicator(
        indicator_type: params.require(:indicator)[:indicator_type],
        options: prepare_options
      )

      if indicator.valid?
        head :ok
      else
        template.destroy!
        render json: indicator.errors, status: :unprocessable_entity
      end
    else
      render json: template.errors, status: :unprocessable_entity
    end
  end

  private

  def prepare_options
    type = params.require(:indicator)[:indicator_type]
    option_params = {
      starting_value: type == 'multi_choice' ? '' : params.require(:indicator)[:starting_value],
      current_value: type == 'multi_choice' ? '' : params.require(:indicator)[:starting_value],
      target_value: type == 'multi_choice' ? params.require(:indicator)[:multiChoiceList].first : params.require(:indicator)[:target_value],
    }
    if type == 'multi_choice'
      list = params.require(:indicator)[:multiChoiceList]
      list.each_with_index do |option, idx|
        option_params["choice_#{idx + 1}"] = option
      end
    end

    option_params
  end
end
