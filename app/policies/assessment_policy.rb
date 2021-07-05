class AssessmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create_ajax?
    check_access_hr
  end

  def add_questions?
    check_access_hr
  end

  def edit_question?
    check_access
  end

  def add_answers?
    true
  end

  private

  def check_access_hr
    ['Super Admin', 'Account Owner', 'HR'].include? user.access_level
  end
end
