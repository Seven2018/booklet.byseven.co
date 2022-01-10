class InterviewFormPolicy < ApplicationPolicy
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

  def show?
    user.hr_or_above?
  end

  def update?
    user.hr_or_above?
  end

  def duplicate?
    user.hr_or_above?
  end

  def interview_form_link_tags?
    user.hr_or_above?
  end

  def destroy?
    user.hr_or_above?
  end
end
