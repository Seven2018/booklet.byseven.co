class WorkshopPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['Super Admin', 'Account Owner', 'HR', 'Employee'].include? user.access_level
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
