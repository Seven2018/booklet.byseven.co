class InterviewReportPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      super
      raise Pundit::NotAuthorizedError, 'not allowed to perform this action' unless
        user.can_create_interview_reports

      scope.where(company: user.company)
    end
  end

  def show?
    create?
  end

  def create?
    user.can_create_interview_reports
  end

  def edit?
    create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
