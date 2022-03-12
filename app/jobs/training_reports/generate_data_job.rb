class TrainingReports::GenerateDataJob < ApplicationJob
  def perform(training_report_id)
    training_report = TrainingReport.find training_report_id
    TrainingReports::GenerateData.call training_report: training_report
  end
end
