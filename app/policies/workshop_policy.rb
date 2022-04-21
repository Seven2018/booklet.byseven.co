class WorkshopPolicy < ApplicationPolicy
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
