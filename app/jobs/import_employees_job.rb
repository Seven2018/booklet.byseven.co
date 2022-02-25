class ImportEmployeesJob < ApplicationJob
  def perform(file, company_id, invited_by_id, send_invite)
    @users = User.import(file, company_id, invited_by_id, send_invite)
  end
end
