class CompanyInfo
  class << self
    def dev_email
      [ENV['DEV_MAIL'], 'william.favreau@byseven.co']
    end

    def no_reply
      'no-reply@byseven.co'
    end

    def mailer_from
      no_reply
    end
  end
end
