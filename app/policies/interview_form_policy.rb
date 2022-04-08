class InterviewFormPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError, 'not allowed to view this action' unless
        user.can_create_templates

      scope.all
    end
  end

  def create?
    user.can_create_templates && record.company_id == user.company_id
  end

  def show?
    create?
  end

  def edit?
    create? && !record.used?
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
end
