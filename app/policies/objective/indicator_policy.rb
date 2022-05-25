class Objective::IndicatorPolicy < ApplicationPolicy

  def update?
    # user == record.objective_element.manager
    true
  end

end
