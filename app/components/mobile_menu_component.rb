
class MobileMenuComponent < ViewComponent::Base
  def initialize(user)
    @user = user
  end

  def active_applications
    return [] unless @user&.company

    @user.company.active_applications
  end
end
