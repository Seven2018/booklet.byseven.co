class TagCategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    check_access_hr
  end

  def update_tag_category?
    check_access_hr
  end

  def destroy?
    check_access_hr
  end

  private

  def check_access_hr
    ['Super Admin', 'Account Owner', 'HR'].include?(user.access_level)
  end
end
