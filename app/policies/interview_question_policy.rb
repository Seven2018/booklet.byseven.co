class InterviewQuestionPolicy < ApplicationPolicy

  def create?
    user.can_create_templates
  end

  def update?
    create?
  end

  def duplicate?
    create?
  end

  def add_mcq_option?
    create?
  end

  def edit_mcq_option?
    create?
  end

  def delete_mcq_option?
    create?
  end

  def destroy?
    create?
  end

end
