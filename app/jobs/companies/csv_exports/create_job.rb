class Companies::CsvExports::CreateJob < ApplicationJob
  def perform(csv_export_id)
    csv_export = CsvExport.find csv_export_id
    Companies::CsvExports::Create.call csv_export: csv_export
  end
end
