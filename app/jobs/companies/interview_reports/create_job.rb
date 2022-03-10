class Companies::InterviewReports::CreateJob < ApplicationJob
  def perform(interview_report_id)
    interview_report = InterviewReport.find interview_report_id
    Companies::InterviewReports::Create.call interview_report: interview_report
  end
end
