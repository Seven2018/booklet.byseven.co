class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError, 'not allowed to view this action' unless
        user.can_read_employees && user.company_id.present?

      scope.where(company: user.company)
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

  def unlink_from_company?
    user.hr_or_above?
  end

  def update?
    true
  end

  def destroy?
    user.hr_or_above?
  end

  def recommendation?
    user.hr_or_above?
  end

  def book_users?
    user.hr_or_above?
  end
end
