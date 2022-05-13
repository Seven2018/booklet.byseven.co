class FolderPolicy < ApplicationPolicy
  def show?
    true
  end

  def edit?
    create?
  end

  def create?
    user.can_create_contents
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def duplicate?
    create?
  end

  def folder_manage_children?
    create?
  end
end
