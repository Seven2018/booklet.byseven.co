class Objective::ElementDecorator < Draper::Decorator
  delegate_all
  decorates_association :objective_indicator

  def completion
    objective_indicator.completion
  end
end
