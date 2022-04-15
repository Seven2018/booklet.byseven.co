class ContentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError, 'not allowed to view this action' unless
        read? && user.company_id.present?

      scope.where(company: user.company)
    end
  end

  def show?
    true
  end

  def read?
    user.can_read_contents
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
