# reload!; InterviewReports::Classic::ToCsv.call(interview_report: InterviewReport.last)
module InterviewReports
  module Classic
    class ToCsv < InterviewReports::ToCsv
      def call
        columns = [
            @interview_report.tag_category.name,
            'Employees count',
            'Interviews sets - Total',
            'Interviews sets - Submitted',
            'Interviews sets - Submitted/Total',
            'Interviews sets - In progress',
            'Interviews sets - In Progress/Total',
            'Interviews sets - Not started',
            'Interviews sets - Not Started/Total',
            'Interviews sets - Started Total'
            ]

        CSV.generate(headers: true) do |csv|
          csv << columns
          @interview_report.tag_category.tags.order(tag_name: :asc).each do |tag|
            employees = User.where(company: company).where_exists(:user_tags, tag_id: tag.id)

            analytics_hash = {}
            employees.each{|x| analytics_hash[x.id] = []}

            campaigns_detes = campaigns.map{|x| x.interviews.group_by(&:employee_id)}
            campaigns_detes.each{|x| x.each{|y,z| analytics_hash[y] << z if analytics_hash.key?(y)}}

            interviews_sets_total = 0
            interviews_sets_completed = 0
            interviews_sets_not_started = 0
            analytics_hash.each{|x, y| interviews_sets_total += y.count;
                                  interviews_sets_completed += y.map{|z| z.map{|z1| z1.submitted? && z1.locked_at.nil?}.uniq == [true]}.select(&:itself).count;
                                  interviews_sets_not_started += y.map{|z| z.map{|z1| z1.submitted?}.uniq == [false]}.select(&:itself).count;
                                }
            employees_count = 0
            analytics_hash.each{|x,y| employees_count += 1 if y.count > 0}

            interviews_sets_in_progress = interviews_sets_total - interviews_sets_completed - interviews_sets_not_started
            interviews_sets_completed_by_total = interviews_sets_total > 0 ? (interviews_sets_completed.fdiv(interviews_sets_total)*100).round : 0
            interviews_sets_not_started_by_total = interviews_sets_total > 0 ? (interviews_sets_not_started.fdiv(interviews_sets_total)*100).round : 0
            interviews_sets_in_progress_by_total = interviews_sets_total > 0 ? (interviews_sets_in_progress.fdiv(interviews_sets_total)*100).round : 0
            interviews_set_total_ongoing = interviews_sets_in_progress_by_total + interviews_sets_completed_by_total

            line = []

            line << tag.tag_name
            line << employees_count
            line << interviews_sets_total
            line << interviews_sets_completed
            line << interviews_sets_completed_by_total.to_s + '%'
            line << interviews_sets_in_progress
            line << interviews_sets_in_progress_by_total.to_s + '%'
            line << interviews_sets_not_started
            line << interviews_sets_not_started_by_total.to_s + '%'
            line << interviews_set_total_ongoing.to_s + '%'

            csv << line
          end
        end
      end
    end
  end
end
