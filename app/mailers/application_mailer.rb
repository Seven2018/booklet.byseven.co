class ApplicationMailer < ActionMailer::Base
  helper(EmailHelper)
  default from: CompanyInfo.mailer_from
  layout 'mailer'
end
