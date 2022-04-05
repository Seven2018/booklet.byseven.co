class PermissionsPolicy < ApplicationPolicy
  def edit?
    user.hr_or_above?
  end

  def update?
    edit?
  end
end
