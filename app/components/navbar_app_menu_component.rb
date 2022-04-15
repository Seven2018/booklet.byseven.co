
class NavbarAppMenuComponent < ViewComponent::Base
  def initialize(user:, color:)
    @user = user
    @color = color
  end

  def active_applications
    return [] unless @user&.company

    @user.company.active_applications
  end
end

