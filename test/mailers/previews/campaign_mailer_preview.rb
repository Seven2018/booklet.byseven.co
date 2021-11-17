# Preview all emails at http://localhost:3000/rails/mailers/campaign_mailer
class CampaignMailerPreview < ActionMailer::Preview

  def invite_employee
    CampaignMailer.with(User.first).invite_employee(User.find(2), User.first, Interview.first)
  end
end
