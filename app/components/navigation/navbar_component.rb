# frozen_string_literal: true

class Navigation::NavbarComponent < ViewComponent::Base
  include Companies::Applications

  def initialize(active_app:, user:, controller_action:)
    @active_app = active_app
    @user = user
    @controller_action = controller_action
  end
end
