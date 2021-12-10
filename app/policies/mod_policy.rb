class ModPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['Super Admin', 'Account Owner', 'HR', 'Employee'].include? user.access_level
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def create?
    user.hr_or_above?
  end

  def duplicate?
    user.hr_or_above?
  end

  def edit_question?
    user.hr_or_above?
  end

  def update?
    user.hr_or_above?
  end

  def destroy?
    user.hr_or_above?
  end

  def move_up?
    user.hr_or_above?
  end

  def move_down?
    user.hr_or_above?
  end
end
