class ImportEmployeesJob < ApplicationJob
  include SuckerPunch::Job

  def perform(file, company_id, invited_by_id, send_invite)
    @users = User.import(file, company_id, invited_by_id, send_invite)
  end
end
