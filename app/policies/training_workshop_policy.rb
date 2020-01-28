class TrainingWorkshopPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['Super Admin', 'Admin', 'HR', 'Employee'].include? user.access_level
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def show?
    true
  end

  def create?
    check_access
  end

  def update?
    check_access
  end

  def copy?
    check_access
  end

  def book_training_workshop?
    check_access
  end

  private

  def check_access
    ['Super Admin', 'Admin', 'HR'].include? user.access_level
  end
end
