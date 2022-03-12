module InterviewReports
  class GenerateData
    def self.call(**params)
      new(params).call
    end

    def initialize(interview_report:)
      @interview_report = interview_report
    end

    def call
      @interview_report.started!
      @interview_report.update data: data
      # return @interview_report.failed! if condition (if applicable)
      @interview_report.done!
    end

    def data
      return campaigns.to_csv_analytics(company.id, @interview_report.tag_category.id) if @interview_report.classic_mode?

      return campaigns.to_csv_data(company.id) if @interview_report.data_mode?

      raise StandardError, 'Unknown InterviewReport mode'
    end

    def company
      @company ||= @interview_report.creator.company
    end

    def campaigns
      @campaigns ||=
        company.campaigns.where_exists(
          :interviews,
          'date >= ? AND date <= ?',
          @interview_report.start_time,
          @interview_report.end_time
        )
    end
  end
end
