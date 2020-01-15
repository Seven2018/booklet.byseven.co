class AttendeePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user_signed_in?
  end

  def destroy?
    user_signed_in?
  end
end
