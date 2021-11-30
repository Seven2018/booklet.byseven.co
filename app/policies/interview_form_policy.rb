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
    check_access_hr
  end

  def show?
    check_access_manager
  end

  def update?
    check_access_hr
  end

  def duplicate?
    check_access_hr
  end

  def interview_form_link_tags?
    check_access_hr
  end

  def destroy?
    check_access_hr
  end

  private

  def check_access_manager
    ['Super Admin', 'Account Owner', 'HR', 'Manager'].include? user.access_level
  end

  def check_access_hr
    ['Super Admin', 'Account Owner', 'HR'].include? user.access_level
  end
end
