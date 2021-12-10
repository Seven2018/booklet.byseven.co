class InterviewFormPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['Super Admin', 'Account Owner', 'HR', 'Manager'].include? user.access_level
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
    check_access_manager
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

  private

  def check_access_manager
    ['Super Admin', 'Account Owner', 'HR', 'Manager'].include? user.access_level
  end
end
