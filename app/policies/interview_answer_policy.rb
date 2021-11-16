class InterviewAnswerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['Super Admin', 'Account Owner', 'HR', 'Manager', 'HR-light', 'Manager-light', 'Employee'].include? user.access_level
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def answer_question?
    check_access
  end

  private

  def check_access_manager
    ['Super Admin', 'Account Owner', 'HR', 'Manager'].include? user.access_level
  end

  def check_access
    ['Super Admin', 'Account Owner', 'HR', 'Manager', 'HR-light', 'Manager-light', 'Employee'].include? user.access_level
  end
end
