class SessionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.employee_or_above?
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def book_sessions?
    user.hr_or_above?
  end

  def update?
    user.hr_or_above?
  end

  def destroy?
    user.hr_or_above?
  end
end
