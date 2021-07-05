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
    check_access_owner
  end

  def destroy?
    check_access_owner
  end

  private

  def check_access_hr
    ['Super Admin', 'Account Owner', 'HR'].include? user.access_level
  end

  def check_access_owner
    user.access_level == 'Account Owner'
  end
end
