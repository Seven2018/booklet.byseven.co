class ModPolicy < ApplicationPolicy
  def create?
    user.can_create_campaigns
  end

  def duplicate?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def move_up?
    create?
  end

  def move_down?
    create?
  end
end
