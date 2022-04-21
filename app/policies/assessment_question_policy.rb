class AssessmentQuestionPolicy < ApplicationPolicy
  def view_mode?
    true
  end

  def update?
    user.can_create_campaigns
  end

  def move_up?
    update?
  end

  def move_down?
    update?
  end

  def destroy?
    update?
  end
end
