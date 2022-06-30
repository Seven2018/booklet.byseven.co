class InterviewReportSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :created_at, :mode, :start_time, :end_time, :processing, :csv_path, :xlsx_path

  belongs_to :creator

  def processing
    object.processing?
  end

  def csv_path
    interviews_report_path(object, format: :csv)
  end

  def xlsx_path
    interviews_report_path(object, format: :xlsx)
  end
end
