class CampaignMailer < ApplicationMailer
  default from: 'no-reply@byseven.co'

  def invite_employee(owner, employee, interview)
    @employee = employee
    @owner = owner
    @interview = interview
    mail(to: @employee.email, subject: "#{@employee.company.name} - EFA")
  end
end
