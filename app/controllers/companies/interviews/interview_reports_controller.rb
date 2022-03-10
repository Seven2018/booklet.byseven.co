class Companies::Interviews::InterviewReportsController < ApplicationController
  skip_after_action :verify_authorized # temp
  skip_after_action :verify_policy_scoped # temp

  def show
    respond_to do |format|
      format.csv  { send_data interview_report.to_csv,  filename: interview_report.filename('.csv')  }
      format.xlsx { send_file interview_report.to_xlsx, filename: interview_report.filename('.xlsx') }
    end
  end

  def create
    interview_report = InterviewReport.new interview_report_params
    if interview_report.save
      Companies::InterviewReports::CreateJob.perform_later interview_report.id
      flash[:notice] = "Export Csv en cours de création: rafraichir dans 1 min !"
    else
      flash[:alert] = interview_report.errors.full_messages.join(',')
    end
    redirect_to interviews_reports_path
  end

  def destroy
    interview_report.destroy
    flash[:notice] = "Export Csv détruit !"
    redirect_to interviews_reports_path
  end

  private

  def interview_report
    @interview_report ||= InterviewReport.find params[:id]
  end

  def interview_report_params
    params.require(:interview_report)
          .permit(:tag_category_id, :mode, :start_time, :end_time, :company_id, :creator_id)
  end
end
