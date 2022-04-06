class InterviewQuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.manager_or_above?
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def create?
    user.hr_or_above?
  end

  def update?
    user.hr_or_above?
  end

  def duplicate?
    user.hr_or_above?
  end

  def add_mcq_option?
    user.hr_or_above?
  end

  def edit_mcq_option?
    user.hr_or_above?
  end

  def delete_mcq_option?
    user.hr_or_above?
  end

  def destroy?
    user.hr_or_above?
  end
end
