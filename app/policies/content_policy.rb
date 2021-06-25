class ContentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['Super Admin', 'Admin', 'HR', 'Employee'].include? user.access_level
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def create?
    check_access_hr
  end

  def show?
    true
  end

  def edit_mode?
    check_access_hr
  end

  def update?
    check_access_hr
  end

  def duplicate?
    check_access_hr
  end

  def destroy?
    check_access_hr
  end

  def destroy_content?
    check_access_hr
  end

  def filter?
    true
  end

  def book?
    check_access_hr
  end

  private

  def check_access
    ['Super Admin', 'Admin', 'HR', 'Employee'].include? user.access_level
  end

  def check_access_hr
    ['Super Admin', 'Admin', 'HR'].include? user.access_level
  end
end
