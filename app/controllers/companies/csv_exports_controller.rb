class Companies::CsvExportsController < ApplicationController
  skip_after_action :verify_authorized # temp
  skip_after_action :verify_policy_scoped # temp

  def show
    respond_to do |format|
      format.csv {
        send_data csv_export.data.to_s, filename: csv_export.filename
      }
    end
  end

  def create
    csv_export = CsvExport.new csv_export_params
    if csv_export.save
      Companies::CsvExports::CreateJob.perform_later csv_export.id
      flash[:notice] = "Export Csv en cours de création: rafraichir dans 1 min !"
    else
      flash[:alert] = csv_export.errors.full_messages
    end
    redirect_to campaigns_report_path
  end

  def destroy
    csv_export.destroy
    flash[:notice] = "Export Csv détruit !"
    redirect_to campaigns_report_path
  end

  private

  def csv_export
    @csv_export ||= CsvExport.find params[:id]
  end

  def csv_export_params
    params.require(:csv_export)
          .permit(:category, :mode, :start_time, :end_time, :company_id)
  end
end
