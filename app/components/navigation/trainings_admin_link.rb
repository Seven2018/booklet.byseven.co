# frozen_string_literal: true

class Navigation::TrainingsAdminLink < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  def admin_link_text
    'Create'
  end

  def should_render?
    TrainingPolicy.new(@user, nil).create? ||
      TrainingReportPolicy.new(@user, nil).create?
  end
end
