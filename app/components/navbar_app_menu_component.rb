
class NavbarAppMenuComponent < ViewComponent::Base
  def initialize(user:, color:)
    @user = user
    @color = color
  end
end

