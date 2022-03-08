class Companies::Interviews::CsvExportsController < ApplicationController
  skip_after_action :verify_authorized # temp
  skip_after_action :verify_policy_scoped # temp

  def show
    respond_to do |format|
      format.csv  { send_data csv_export.to_csv,  filename: csv_export.filename('.csv')  }
      format.xlsx { send_file csv_export.to_xlsx, filename: csv_export.filename('.xlsx') }
    end
  end

  def create
    csv_export = CsvExport.new csv_export_params
    if csv_export.save
      Companies::CsvExports::CreateJob.perform_later csv_export.id
      flash[:notice] = "Export Csv en cours de création: rafraichir dans 1 min !"
    else
      flash[:alert] = csv_export.errors.full_messages.join(',')
    end
    redirect_to interviews_reports_path
  end

  def destroy
    csv_export.destroy
    flash[:notice] = "Export Csv détruit !"
    redirect_to interviews_reports_path
  end

  private

  def csv_export
    @csv_export ||= CsvExport.find params[:id]
  end

  def csv_export_params
    params.require(:csv_export)
          .permit(:tag_category_id, :mode, :start_time, :end_time, :company_id, :creator_id)
  end
end