class UserPolicy < ApplicationPolicy
  class Scope < Scope
    attr_reader :user, :scope, :can_read

    def resolve
      super
      raise Pundit::NotAuthorizedError, 'not allowed to perform this action' unless
        can_read

      scope.where(company: user.company)
    end

    def can_read
      user.can_read_employees
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
    user.can_edit_employees || user.id == record.id
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
