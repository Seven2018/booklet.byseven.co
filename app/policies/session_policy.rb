class SessionPolicy < ApplicationPolicy
  def book_sessions?
    user.can_create_trainings
  end

  def update?
    book_sessions?
  end

  def destroy?
    book_sessions?
  end
end
