# frozen_string_literal: true

class Navigation::InterviewsAdminLink < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  def admin_link_text
    'Admin'
  end

  def should_render?(campaigns_path, interview_forms_path, interviews_reports_path)
    if CampaignPolicy.new(@user, nil).create?
      campaigns_path
    elsif InterviewFormPolicy.new(@user, nil).create?
      interview_forms_path
    elsif InterviewReportPolicy.new(@user, nil).create?
      interviews_reports_path
    else
      false
    end
  end
end
