class InterviewReports::GenerateDataJob < ApplicationJob
  def perform(interview_report_id)
    interview_report = InterviewReport.find interview_report_id
    InterviewReports::GenerateData.call interview_report: interview_report
  end
end
