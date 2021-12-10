class InterviewPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.manager_or_above?
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def create?
    user.manager_or_above?
  end

  def show?
    user.employee_or_above?
  end

  def answer_question?
    user.employee_or_above?
  end

  def update_interviews?
    user.manager_or_above?
  end
end
