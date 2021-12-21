class ApplicationMailer < ActionMailer::Base
  default from: CompanyInfo.mailer_from
  layout 'mailer'
end
