class CompanyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    check_access_super
  end

  def show?
    check_access
  end

  def edit?
    check_access_hr
  end

  def update?
    check_access_hr
  end

  def destroy?
    check_access_super
  end

  private

  def check_access
    ['Super Admin', 'Admin', 'HR'].include? user.access_level
  end

  def check_access_hr
    ['Super Admin', 'Admin', 'HR'].include? user.access_level
  end

  def check_access_super
    user.access_level == 'Super Admin'
  end
end
