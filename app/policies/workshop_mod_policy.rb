class ContentModPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['Super Admin', 'Admin', 'HR', 'Employee'].include? user.access_level
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def create?
    check_access
  end

  def move_up?
    check_access
  end

  def move_down?
    check_access
  end

  private

  def check_access
    ['Super Admin', 'Admin', 'HR', 'Manager'].include? user.access_level
  end
end
