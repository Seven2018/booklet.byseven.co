class InterviewFormPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError, 'not allowed to view this action' unless
        user.can_create_templates && user.company_id.present?

      scope.where(company: user.company)
    end
  end

  def create?
    user.can_create_templates
  end

  def show?
    create?
  end

  def edit?
    create? && record.company_id == user.company_id && !record.used?
  end

  def update?
    edit?
  end

  def duplicate?
    edit?
  end

  def interview_form_link_tags?
    edit?
  end

  def destroy?
    edit?
  end

  def toggle_tag?
    user.hr_or_above? && !record.used?
  end
end
