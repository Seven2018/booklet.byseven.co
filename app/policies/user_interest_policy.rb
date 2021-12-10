class UserInterestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.hr_or_above?
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def create?
    true
  end

  def recommend?
    user.hr_or_above?
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
