class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError, 'not allowed to view this action' unless
        user.can_read_employees && user.company_id.present?

      scope.where(company: user.company)
    end
  end

  def create?
    user.can_create_employees
  end

  def import_users?
    create?
  end

  def show?
    true
  end

  def edit?
    user.can_edit_employees ||
      user.id == record.id
  end

  def update?
    edit?
  end

  def complete_profile?
    true
  end

  def link_to_company?
    true
  end

  def unlink_from_company?
    create?
  end

  def destroy?
    create?
  end

  def recommendation?
    create?
  end

  def book_users?
    create?
  end
end
