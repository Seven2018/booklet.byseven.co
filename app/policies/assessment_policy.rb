class AssessmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create_ajax?
    user.hr_or_above?
  end

  def add_questions?
    user.hr_or_above?
  end

  def edit_question?
    user.hr_or_above?
  end

  def add_answers?
    true
  end
end
