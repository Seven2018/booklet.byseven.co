# reload!; InterviewReports::Data::ToCsv.call(interview_report: InterviewReport.last)
module InterviewReports
  module Data
    class ToCsv < InterviewReports::ToCsv
      include Rails.application.routes.url_helpers

      def call
        tag_categories = TagCategory.where(company: company).where.not(name: 'Job Title').order(position: :asc)

        columns = ['Campaign ID',
            'Campaign Title',
            'Campaign URL',
            'Campaign Type',
            'Interview Type',
            'Interviewer Email',
            'Interviewer Fullname',
            'Interviewee Email',
            'Interviewee Fullname',
            'Interviewee Job Title',
            'Interviewee Completion',
            'Interview Locked At',
            'Deadline'] + tag_categories.map(&:name)
        CSV.generate(headers: true) do |csv|
          csv << columns
          campaigns.each do |campaign|
            campaign.interviews.each do |interview|
              employee    = interview.employee
              interviewer = interview.interviewer
              next unless employee # should NOT happen

              line = []
              line << campaign.id
              line << campaign.title
              line << campaign_url(campaign, employee_id: employee.id, host: ENV['APP_DOMAIN'])
              line << campaign.campaign_type
              line << interview.label
              line << interviewer.email
              line << interviewer.fullname
              line << employee.email
              line << employee.fullname
              line << employee.job_title
              line << campaign.completion_for(employee)
              line << interview.locked_at
              line << (interview.date.presence || campaign.deadline).strftime('%d/%m/%Y')
              tag_categories.each do |tag_category|
                tag = UserTag.find_by(tag_category: tag_category, user: employee)
                tag = tag.present? ? tag.tag.tag_name : ' '
                line << tag
              end
              csv << line
            end
          end
        end
      end
    end
  end
end
