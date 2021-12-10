class ImportEmployeesJob < ApplicationJob
  include SuckerPunch::Job

  def perform(file, company_id)
    @users = User.import(file, company_id)
  end
end
