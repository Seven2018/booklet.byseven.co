class UserTagPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError, 'not allowed to perform this action' unless
        user.can_edit_employees

      scope.all
    end
  end

  def create?
    user.can_edit_employees
  end
end
