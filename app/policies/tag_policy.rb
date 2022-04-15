class TagPolicy < ApplicationPolicy
  def create?
    user.can_edit_employees
  end

  def update_tag?
    create?
  end

  def destroy?
    create?
  end
end
