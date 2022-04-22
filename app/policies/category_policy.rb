class CategoryPolicy < ApplicationPolicy
  def create?
    user.can_create_trainings
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
