class SkillPolicy < ApplicationPolicy
  def create?
    user.admin?
  end

  def show?
    create?
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
