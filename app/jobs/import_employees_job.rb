class ImportEmployeesJob < ApplicationJob
  def perform(csv_import_user_id, send_invite)
    csv_import_user = CsvImportUser.find csv_import_user_id
    return if csv_import_user.processed?

    User.import(
      csv_import_user.data,
      csv_import_user.creator.company.id,
      csv_import_user.creator.id,
      send_invite
    )
    csv_import_user.processed!
  end
end
