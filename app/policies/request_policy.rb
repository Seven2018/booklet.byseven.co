class RequestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['Super Admin', 'HR', 'Employee'].include? user.access_level
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def create?
    check_access
  end

  def show?
    check_access
  end

  def edit?
    check_access
  end

  def update?
    check_access
  end

  def destroy?
    check_access
  end

  private

  def check_access
    ['Super Admin', 'HR', 'Employee'].include? user.access_level
  end
end
