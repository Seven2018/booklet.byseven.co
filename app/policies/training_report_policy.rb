class TrainingReportPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError, 'not allowed to view this action' unless
        user.can_create_training_reports && user.company_id.present?

      scope.where(company: user.company)
    end
  end

  def show?
    create?
  end

  def create?
    user.can_create_training_reports
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
