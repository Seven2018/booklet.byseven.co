class InterviewPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.manager_or_above? && user.company_id.present?
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def create?
    # used in campaign_drafts TODO non regression test
    user.manager_or_above?
  end

  def show?
    return true if user.hr_or_above?

    case
    when record.employee?
      user == record.employee || user == record.interviewer
    when record.manager?
      user == record.interviewer
    when record.crossed?
      user == record.interviewer || user == record.employee
    end
  end

  def answer_question?
    return false if record.locked?

    case
    when record.crossed? || record.manager?
      user == record.interviewer
    when record.employee?
      user == record.employee
    end
  end

  def complete_interview?
    case
    when record.crossed? || record.manager?
      user == record.interviewer
    when record.employee?
      user == record.employee
    end
  end

  def lock_interview?
    user == record.interviewer
  end

  def unlock_interview?
    user.hr_or_above?
  end

  def update_interviews?
    user == record.interviewer || user.hr_or_above?
  end
end
