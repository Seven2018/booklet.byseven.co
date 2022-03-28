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
      @interview_report.update data: to_csv.call(interview_report: @interview_report)
      # return @interview_report.failed! if condition (if applicable)
      @interview_report.done!
    end
    private

    def to_csv
      "InterviewReports::#{@interview_report.mode.capitalize}::ToCsv".constantize
    end
  end
end
