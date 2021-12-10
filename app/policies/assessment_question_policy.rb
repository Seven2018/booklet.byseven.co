class AssessmentQuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def view_mode?
    true
  end

  def update?
    user.hr_or_above?
  end

  def move_up?
    user.hr_or_above?
  end

  def move_down?
    user.hr_or_above?
  end

  def destroy?
    user.hr_or_above?
  end
end
