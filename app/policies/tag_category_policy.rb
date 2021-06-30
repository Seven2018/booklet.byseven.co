class TagCategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    check_access
  end

  def update_tag_category?
    check_access
  end

  def destroy?
    check_access
  end

  private

  def check_access
    ['Super Admin', 'Account Owner', 'HR'].include?(user.access_level)
  end
end
