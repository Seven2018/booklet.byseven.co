class Interviews::ReportsController < ApplicationController
  before_action :show_navbar_campaign, :show_navbar_admin, :ensure_company

  def index
    @reports = policy_scope(InterviewReport).order(created_at: :desc)
  end

  # def new
  #   authorize InterviewReport.new
  # end
  #
  # def create
  #   interview_report = InterviewReport.new interview_report_params
  #   authorize interview_report
  #   if interview_report.save
  #     InterviewReports::GenerateDataJob.perform_later interview_report.id
  #     flash[:notice] = "Generating report: refresh in 1 min !"
  #   else
  #     flash[:alert] = interview_report.errors.full_messages.join(',')
  #   end
  #   redirect_to interviews_reports_path
  # end

  def edit
    authorize interview_report
  end

  def show
    authorize interview_report
    respond_to do |format|
      format.csv  { send_data interview_report.to_csv,  filename: interview_report.filename('.csv')  }
      format.xlsx { send_file interview_report.to_xlsx, filename: interview_report.filename('.xlsx') }
    end
  end

  def destroy
    authorize interview_report
    interview_report.destroy
    flash[:notice] = "Report destroyed !"
    redirect_to interviews_reports_path
  end

  private

  def interview_report
    @interview_report ||= current_user.interview_report
  end

  def interview_report_params
    params.require(:interview_report)
          .permit(:tag_category_id, :mode, :start_time, :end_time, :company_id, :creator_id)
  end
end
