class AddInputsToInterviewReports < ActiveRecord::Migration[6.0]
  def change
    add_column :interview_reports, :inputs, :jsonb, default: {}
  end
end
