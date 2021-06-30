class TagPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    check_access
  end

  def show?
    check_access_manager
  end

  def edit?
    check_access
  end

  def update_tag?
    check_access
  end

  def destroy?
    check_access
  end

  def destroy?
    check_access
  end

  private

  def check_access
    ['Super Admin', 'Account Owner', 'HR'].include?(user.access_level)
  end

  def check_access_manager
    ['Super Admin', 'Account Owner', 'HR', 'Manager'].include?(user.access_level)
  end
end
