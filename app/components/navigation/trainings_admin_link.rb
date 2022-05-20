# frozen_string_literal: true

class Navigation::TrainingsAdminLink < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  def admin_link_text
    'Admin'
  end

  def should_render?(trainings_path, trainings_reports_path)
    if TrainingPolicy.new(@user, nil).create?
      trainings_path
    elsif TrainingReportPolicy.new(@user, nil).create?
      trainings_reports_path
    else
      false
    end
  end
end
