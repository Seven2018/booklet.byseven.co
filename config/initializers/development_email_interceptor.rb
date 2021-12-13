unless Rails.env.production? || Rails.env.stating?
  require "email_interceptor"
  ActionMailer::Base.register_interceptor(EmailInterceptor)
end
