class TagCategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.hr_or_above?
  end

  def update_tag_category?
    user.hr_or_above?
  end

  def destroy?
    user.hr_or_above?
  end
end
