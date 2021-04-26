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

  def view_mode?
    true
  end

  def create?
    check_access
  end

  def update?
    check_access
  end

  def update_book?
    check_access
  end

  def destroy?
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
    ['Super Admin', 'Admin', 'HR', 'Manager'].include? user.access_level
  end
end
