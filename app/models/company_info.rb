class CompanyInfo
  class << self
    def dev_email
      'brice.chapuis@byseven.co'
    end

    def no_reply
      'no-reply@byseven.co'
    end

    def mailer_from
      dev_email
    end
  end
end
