class TagCategoryPolicy < ApplicationPolicy
  def create?
    user.can_create_contents
  end

  def update_tag_category?
    create?
  end

  def destroy?
    create?
  end
end
