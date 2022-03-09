# frozen_string_literal: true

namespace :interview_reports do
  desc 'Destroy csv_exports older than 7 days old'
  task destroy_older_than_seven_days_old: :environment do
    InterviewReport.where('created_at < ?', 7.days.ago.beginning_of_day).destroy_all
  end
end
