class Objective::ElementDecorator < Draper::Decorator
  delegate_all
  decorates_association :objective_indicators

  def completion
    objective_indicators.first.completion
  end
end
