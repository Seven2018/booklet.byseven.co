class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['Super Admin', 'Account Owner', 'HR'].include? user.access_level
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def create?
    check_access_hr
  end

  def import_users?
    check_access_hr
  end

  def show?
    true
  end

  def complete_profile?
    true
  end

  def link_to_company?
    true
  end

  def update?
    true
  end

  def destroy?
    check_access_hr
  end

  def organisation?
    check_access_hr
  end

  def recommendation?
    check_access_hr
  end

  def book_users?
    check_access_hr
  end

  private

  def check_access_hr
    ['Super Admin', 'Account Owner', 'HR'].include? user.access_level
  end
end
