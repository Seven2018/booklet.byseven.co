class TrainingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError, 'not allowed to view this action' unless
        user.company_id.present?

      scope.where(company: user.company)
    end
  end

  def my_trainings?
    true
  end

  def my_team_trainings?
    user.manager_or_above?
  end

  def my_team_trainings_user_details?
    user.manager_or_above?
  end

  def create?
    user.can_create_trainings
  end

  def show?
    true
  end

  def destroy?
    create?
  end

  def send_acquisition_reminder_email?
    record.creator == user || user.hr_or_above?
  end
end
