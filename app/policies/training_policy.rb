class TrainingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.employee_or_above?
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

  def show?
    true
  end

  def create?
    user.hr_or_above?
  end

  def destroy?
    user.hr_or_above?
  end
end
