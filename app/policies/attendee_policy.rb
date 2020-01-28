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

  def create_all?
    true
  end

  def destroy_all?
    true
  end

  def invite_user_to_workshop?
    check_access_hr
  end

  def invite_user_to_training?
    check_access_hr
  end

  def mark_as_completed?
    check_access_hr
  end

  def confirm_training?
    true
  end

  def confirm_training_workshop?
    true
  end

  private

  def check_access_hr
    ['Super Admin', 'Admin', 'HR'].include? user.access_level
  end
end
