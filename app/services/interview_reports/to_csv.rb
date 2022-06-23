module InterviewReports
  class ToCsv
    def self.call(**params)
      new(params).call
    end

    def initialize(interview_report:)
      @interview_report = interview_report
    end

    def call
      raise NotImplementedError
    end

    private

    def company
      @company ||= @interview_report.creator.company
    end

    def interview_form_ids
      Interview.joins(:campaign).where(campaign: campaigns).distinct.pluck(:interview_form_id)
    end

    def campaigns
      @campaigns ||=
        company.campaigns.where(id: @interview_report.campaign_ids).where(
          'deadline >= ? AND deadline <= ?',
          @interview_report.start_time,
          @interview_report.end_time
        )
    end
  end
end
