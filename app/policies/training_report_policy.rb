class TrainingReportPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.hr_or_above? && user.company_id.present?
        scope.where(company: user.company)
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def show?
    user.hr_or_above?
  end

  def edit?
    user.hr_or_above?
  end

  def update?
    user.hr_or_above?
  end

  def destroy?
    user.hr_or_above?
  end
end
