class Trainings::ReportsController < ApplicationController
  before_action :show_navbar_training, :show_navbar_admin, :set_company

  def index
    @reports = @company.training_reports.order(created_at: :desc)
  end

  def edit
    training_report
  end

  def update
    if mode == :by_employee && participant_ids.blank?
      flash[:alert] = 'Please select users'
      redirect_to edit_trainings_reports_path and return
    end

    if mode == :by_training && training_ids.blank?
      flash[:alert] = 'Please select trainings'
      redirect_to edit_trainings_reports_path and return
    end

    if training_report.update training_report_params
      TrainingReports::GenerateDataJob.perform_later training_report.id
      flash[:notice] = "Generating report: refresh in 1 min !"
    else
      flash[:alert] = training_report.errors.full_messages.join(',')
    end
    redirect_to trainings_reports_path
  end

  def show
    @training_report = TrainingReport.find params[:id]
    respond_to do |format|
      format.html
      format.csv  { send_data training_report.to_csv,  filename: training_report.filename('.csv')  }
      format.xlsx { send_file training_report.to_xlsx, filename: training_report.filename('.xlsx') }
    end
  end

  def destroy
    training_report.destroy
    flash[:notice] = "Report destroyed !"
    redirect_to trainings_reports_path
  end

  private

  def set_company
    @campaigns = policy_scope(Campaign)
    @company = current_user.company
    authorize @campaigns

    unless @company
      flash[:alert] = "User must be associated to a company !"
      redirect_to root_path and return
    end
  end

  def training_report
    @training_report ||= current_user.training_report
  end

  def participant_ids
    params[:participant_ids].first.split(',').uniq.select(&:present?)
  end

  def training_ids
    params[:training_ids].first.split(',').uniq.select(&:present?)
  end

  def mode
    training_report_params[:mode].to_sym
  end

  def training_report_params
    params.require(:training_report)
          .permit(:mode, :start_time, :end_time, :company_id, :creator_id)
  end

end
