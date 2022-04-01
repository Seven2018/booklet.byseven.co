class TrainingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.employee_or_above? && user.company_id.present?
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
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
    # used in campaign_drafts TODO non regression test
    user.hr_or_above?
  end

  def show?
    true
  end

  # TEMP (NOT USED ATM)
  # def send_reminder_email?
  #   user.hr_or_above?
  # end

  def destroy?
    user.hr_or_above?
  end

  def send_acquisition_reminder_email?
    record.creator == user || user.hr_or_above?
  end
end
