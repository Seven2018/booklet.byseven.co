class InterviewFormPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.hr_or_above? && user.company_id.present?
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def create?
    user.hr_or_above?
  end

  def show?
    user.hr_or_above?
  end

  def edit?
    user.hr_or_above? && record.company_id == user.company_id && !record.used?
  end

  def update?
    user.hr_or_above? && !record.used?
  end

  def duplicate?
    user.hr_or_above? && !record.used?
  end

  def interview_form_link_tags?
    user.hr_or_above?
  end

  def destroy?
    user.hr_or_above? && !record.used?
  end

  def toggle_tag?
    user.hr_or_above? && !record.used?
  end

  def remove_company_tag?
    user.hr_or_above? && !record.used?
  end
end
