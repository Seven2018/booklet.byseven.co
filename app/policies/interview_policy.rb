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

    case
    when record.employee? || record.simple?
      user == record.employee || user == record.owner
    when record.manager?
      user == record.owner
    when record.crossed?
      user == record.owner || user == record.employee
    end
  end

  def answer_question?
    return false if record.locked?

    case
    when record.crossed? || record.manager? || record.simple?
      user == record.owner || user.hr_or_above?
    when record.employee?
      user == record.employee
    end
  end

  def complete_interview?
    case
    when record.crossed? || record.manager? || record.simple?
      user == record.owner
    when record.employee?
      user == record.employee
    end
  end

  def lock_interview?
    user == record.owner
  end

  def update_interviews?
    user.manager_or_above?
  end
end
