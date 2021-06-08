class AssessmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    check_access
  end

  def show?
    true
  end

  def add_questions?
    check_access
  end

  def add_answers?
    true
  end

  def destroy?
    check_access
  end

  def update?
    check_access
  end

  private

  def check_access
    ['Super Admin', 'Admin', 'HR'].include? user.access_level
  end
end
