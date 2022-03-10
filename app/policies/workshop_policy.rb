class WorkshopPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.employee_or_above? && user.company_id.present?
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def show?
    user.hr_or_above? ||
    user == record.training.creator ||
    record.users.includes(user)
  end

  def edit?
    user.hr_or_above? ||
    user == record.training.creator
  end

  def update?
    user.hr_or_above? ||
    user == record.session.training.creator
  end

  def complete_workshop?
    record.users.includes(user.id)
  end
end
