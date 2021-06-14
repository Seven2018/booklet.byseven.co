class ImportEmployeesJob < ApplicationJob
  include SuckerPunch::Job

  def perform(file, company_id)
    #begin
      @users = User.import(file, company_id)
    #rescue
    #end
  end

end
