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
    return true if user.hr_or_above?

    answer_question?
  end

  def answer_question?
    case
    when record.crossed? || record.hr?
      user == record.owner
    when record.employee?
      user == record.employee
    end
  end

  def update_interviews?
    user.manager_or_above?
  end
end
