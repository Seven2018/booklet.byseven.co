class UserInterestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError, 'not allowed to perform this action' unless
        user.can_edit_employees

      scope.all
    end
  end

  def create?
    true
  end

  def recommend?
    user.can_edit_employees
  end

  def update_recommendation?
    true
  end

  def destroy?
    true
  end

  def complete_content?
    true
  end
end
