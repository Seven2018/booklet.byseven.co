# frozen_string_literal: true

class Navigation::InterviewsAdminLink < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  def admin_link_text
    'Create'
  end

  def should_render?
    CampaignPolicy.new(@user, nil).create? ||
      InterviewFormPolicy.new(@user, nil).create? ||
      InterviewReportPolicy.new(@user, nil).create?
  end
end
