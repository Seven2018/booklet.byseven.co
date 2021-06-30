class UserPolicy < ApplicationPolicy
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
    check_access
  end

  def show?
    true
  end

  def complete_profile?
    true
  end

  def update?
    true
  end

  def destroy?
    check_access
  end

  private

  def check_access
    ['Super Admin', 'Account Owner', 'HR'].include? user.access_level
  end
end
