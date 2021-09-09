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
    check_access_hr
  end

  def move_up?
    check_access_hr
  end

  def move_down?
    check_access_hr
  end

  def destroy?
    check_access_hr
  end

  private

  def check_access_hr
    ['Super Admin', 'Account Owner', 'HR'].include? user.access_level
  end
end
