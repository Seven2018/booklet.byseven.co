class CompanyPolicy < ApplicationPolicy
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
