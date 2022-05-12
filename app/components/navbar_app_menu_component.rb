
class NavbarAppMenuComponent < ViewComponent::Base
  def initialize(user:, color:, hover_background_color: '')
    @user = user
    @color = color
    @hover_background_color = hover_background_color
  end

  def active_applications
    return [] unless @user&.company

    @user.company.active_applications
  end
end

