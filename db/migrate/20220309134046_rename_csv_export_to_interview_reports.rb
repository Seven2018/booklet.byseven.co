class RenameCsvExportToInterviewReports < ActiveRecord::Migration[6.0]
  def change
    rename_table :csv_exports, :interview_reports
  end
end
