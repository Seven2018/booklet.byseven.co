class UserInterestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['Super Admin', 'Account Owner', 'HR'].include? user.access_level
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
    check_access_hr
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

  private

  def check_access_hr
    ['Super Admin', 'Account Owner', 'HR'].include?(user.access_level)
  end
end
