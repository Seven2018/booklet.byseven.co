class ContentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['Super Admin', 'Account Owner', 'HR', 'Employee'].include? user.access_level
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def show?
    true
  end

  def edit_mode?
    check_access_hr
  end

  def create?
    check_access_hr
  end

  def update?
    check_access_hr
  end

  def duplicate?
    check_access_hr
  end

  def destroy_content?
    check_access_hr
  end

  private

  def check_access_hr
    ['Super Admin', 'Account Owner', 'HR'].include? user.access_level
  end
end
