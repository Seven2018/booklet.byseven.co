class ImportEmployeesJob < ApplicationJob
  include SuckerPunch::Job

  def perform(file, company_id, invited_by_id)
    @users = User.import(file, company_id, invited_by_id)
  end
end
