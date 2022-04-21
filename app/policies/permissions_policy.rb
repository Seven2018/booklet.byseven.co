class PermissionsPolicy < ApplicationPolicy
  def edit?
    user.can_edit_permissions
  end

  def update?
    edit?
  end
end
