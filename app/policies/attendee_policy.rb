class AttendeePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    true
  end

  def destroy?
    true
  end

  def update?
    true
  end

  def invite_user_to_workshop?
    check_access_hr
  end

  def mark_as_completed?
    check_access_hr
  end

  def confirm_training_workshop?
    true
  end

  private

  def check_access_hr
    ['Super Admin', 'Admin', 'HR'].include? user.access_level
  end
end
