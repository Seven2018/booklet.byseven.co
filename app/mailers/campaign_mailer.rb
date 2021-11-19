class CampaignMailer < ApplicationMailer
  default from: 'no-reply@byseven.co'

  def invite_employee(owner, employee, interview)
    @employee = employee
    @owner = owner
    @interview = interview
    @url = new_user_session_url + "?user_email=#{employee.email.gsub("@", "%40")}&user_token=#{employee.authentication_token}&redirect_to=interviews/#{interview.id}"
    mail(to: @employee.email, subject: "#{@employee.company.name} - EFA")
  end
end
