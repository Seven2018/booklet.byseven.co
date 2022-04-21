class AssessmentPolicy < ApplicationPolicy
  def add_questions?
    edit_question?
  end

  def edit_question?
    user.can_create_campaigns
  end

  def add_answers?
    true
  end
end
