# frozen_string_literal: true

namespace :csv_exports do
  desc 'Destroy csv_exports older than 7 days old'
  task destroy_older_than_seven_days_old: :environment do
    CsvExport.where('created_at < ?', 7.days.ago.beginning_of_day).destroy_all
  end
end
