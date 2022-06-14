class InterviewFormPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      super
      raise Pundit::NotAuthorizedError, 'not allowed to perform this action' unless
        user.can_create_templates

      scope.where(company: user.company)
    end
  end

  def list?
    true
  end

  def create?
    user.can_create_templates
  end

  def show?
    create?
  end

  def edit?
    create? # && record.company_id == user.company_id && !record.used?
  end

  def update?
    edit?
  end

  def duplicate?
    edit?
  end

  def destroy?
    edit?
  end

  def toggle_tag?
    create? && !record.used?
  end

  def remove_company_tag?
    create? && !record.used?
  end

  def search_tags?
    create? && !record.used?
  end
end
