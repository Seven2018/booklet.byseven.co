class TrainingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      super
      scope.where(company: user.company)
    end
  end

  def my_trainings?
    true
  end

  def my_team_trainings?
    user.access_level_int.to_sym != :employee
  end

  def my_team_trainings_user_details?
    create?
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
    record.creator == user || create?
  end
end
