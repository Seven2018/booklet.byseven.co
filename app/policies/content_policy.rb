class ContentPolicy < ApplicationPolicy
  class Scope < Scope
    attr_reader :user, :scope, :can_read

    def resolve
      raise Pundit::NotAuthorizedError, 'not allowed to view this action' unless
        can_read && user.company_id.present?

      scope.where(company: user.company)
    end

    def can_read
      user.can_read_contents
    end
  end

  def show?
    true
  end

  def create?
    user.can_create_contents
  end

  def edit?
    create?
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

  def book_contents?
    user.hr_or_above?
  end
end
