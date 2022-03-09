class Interviews::ReportsController < ApplicationController
  before_action :show_navbar_campaign, :show_navbar_admin, :set_company

  def index
    @reports = @company.interview_reports.order(created_at: :desc)
  end

  def new; end

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

  def show
    respond_to do |format|
      format.csv  { send_data interview_report.to_csv,  filename: interview_report.filename('.csv')  }
      format.xlsx { send_file interview_report.to_xlsx, filename: interview_report.filename('.xlsx') }
    end
  end

  def destroy
    interview_report.destroy
    flash[:notice] = "Export Csv détruit !"
    redirect_to interviews_reports_path
  end

  private

  def set_company
    @campaigns = policy_scope(Campaign)
    @company = current_user.company
    authorize @campaigns

    unless @company
      flash[:alert] = "L'utilisateur doit être associé à une société !"
      redirect_to root_path and return
    end
  end

  def interview_report
    @interview_report ||= InterviewReport.find params[:id]
  end

  def interview_report_params
    params.require(:interview_report)
          .permit(:tag_category_id, :mode, :start_time, :end_time, :company_id, :creator_id)
  end
end
