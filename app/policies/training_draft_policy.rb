class TrainingDraftPolicy < ApplicationPolicy
  def initialize(user)
    @user = user
  end

  def update?
    user.can_create_trainings
  end
end
