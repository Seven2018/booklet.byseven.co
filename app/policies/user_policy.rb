class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.hr_or_above?
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def create?
    user.hr_or_above?
  end

  def import_users?
    user.hr_or_above?
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
    user.hr_or_above?
  end

  def organisation?
    user.hr_or_above?
  end

  def recommendation?
    user.hr_or_above?
  end

  def book_users?
    user.hr_or_above?
  end
end
