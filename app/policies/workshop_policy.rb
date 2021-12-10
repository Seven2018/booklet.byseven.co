class WorkshopPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.employee_or_above?
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def show?
    true
  end

  def edit?
    user.hr_or_above?
  end

  def update?
    user.hr_or_above?
  end
end
