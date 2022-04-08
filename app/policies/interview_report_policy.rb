class InterviewReportPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError, 'not allowed to view this action' unless
        user.can_create_interview_reports && user.company_id.present?

      scope.where(company: user.company)
    end
  end

  def show?
    edit?
  end

  def create?
    user.can_create_interview_reports
  end

  def edit?
    create?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end
end
