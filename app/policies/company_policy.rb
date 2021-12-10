class CompanyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    true
  end

  def update?
    user.account_owner?
  end

  def destroy?
    user.account_owner?
  end
end
