class PagePolicy < ApplicationPolicy
  def initialize(user)
    @user = user
  end

  def catalogue?
    user.can_read_contents
  end
end
