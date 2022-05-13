# frozen_string_literal: true

class Navigation::ObjectivesAdminLink < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  def admin_link_text
    'Admin'
  end

  def should_render?
    Objective::ElementPolicy.new(@user, nil).create?
  end
end
