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
    edit? || complete_workshop?
  end

  def edit?
    user.can_edit_training_workshops ||
      user == record.training.creator
  end

  def update?
    # TODO: check why different from edit?
    user.can_edit_training_workshops ||
      user == record.session.training.creator
  end

  def complete_workshop?
    record.users.includes(user.id)
  end
end
