class InterviewPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      super
      raise Pundit::NotAuthorizedError, 'not allowed to perform this action' unless
        user.can_create_campaigns

      scope.all
    end
  end

  def show?
    return true if user.can_create_campaigns

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

  def lock_interview?
    case
    when record.crossed? || record.manager?
      user == record.interviewer
    when record.employee?
      user == record.employee
    end
  end

  def unlock_interview?
    user.can_create_campaigns
  end

  def archive_interview?
    user == record.employee || user == record.interviewer
  end

  def archive_interviewer_interviews?
    record.where.not(interviewer: user).count == 0
  end
end
