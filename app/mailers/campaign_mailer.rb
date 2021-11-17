class CampaignMailer < ApplicationMailer
  default from: Rails.application.credentials.gmail_username

  def invite_employee(owner, employee, interview)
    @employee = employee
    @owner = owner
    @interview = interview
    mail(to: @employee.email, subject: 'Nouvelle demande entrante !')
  end
end
