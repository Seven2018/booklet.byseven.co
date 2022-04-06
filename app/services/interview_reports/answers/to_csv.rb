# reload!; InterviewReports::Answers::ToCsv.call(interview_report: InterviewReport.last)
module InterviewReports
  module Answers
    class ToCsv < InterviewReports::ToCsv
      def call
        campaign = campaigns.first
        interview_form_id = interview_form_ids.first
        interview_form = InterviewForm.find interview_form_id
        employees = Interview.where(campaign: campaign, interview_form: interview_form).map(&:employee).uniq
        tag_categories = TagCategory.where(company: company).order(position: :asc)

        columns = ['Interview Type',
            'Interview Label',
            'Interviewer email',
            'Interviewer fullname',
            'Interviewee email',
            'Interviewee fullname'] +
            tag_categories.map(&:name) +
            ['Deadline'] +
            interview_form.interview_questions.where.not(question_type: 'separator').order(position: :asc).map{|x| x.rating? ? (x.question.tr(",\n", " ") + " /" + x.options.keys.first) : x.question.tr(",\n", " ")}

        CSV.generate(headers: true) do |csv|
          csv << columns

          employees.sort_by{|x| x.lastname}.each do |employee|

            employee_id = employee.id
            employee_email = employee.email
            employee_fullname = employee.fullname
            employee_tags = tag_categories.map{|category| UserTag.find_by(user: employee, tag_category: category)&.tag&.tag_name || '' }

            interviews_set = [campaign.employee_interview(employee_id), campaign.manager_interview(employee_id), campaign.crossed_interview(employee_id)].compact

            interview_type =
              if interviews_set.count == 1
                interviews_set.first.label
              elsif interviews_set.count == 2
                'Both'
              else
                'Cross'
              end

            interviewer = interviews_set.first.interviewer
            interviewer_email = interviewer.email
            interviewer_fullname = interviewer.fullname
            deadline = interviews_set.first.date.strftime('%d/%m/%Y')

            interviews_set.each do |interview|

              line = []

              line << interview_type
              line << interview.label
              line << interviewer_email
              line << interviewer_fullname
              line << employee_email
              line << employee_fullname
              employee_tags.each{|tag| line << tag}
              line << deadline

              interview.interview_questions.order(position: :asc).each do |question|
                answer = question.interview_answers.find_by(interview: interview)
                next if answer.nil?
                answer_text =
                  if question.rating?
                    "Answer: " + answer.answer
                  elsif question.open_question? || question.mcq?
                    "Answer: " + answer.answer.tr(",\n", " ")
                  elsif question.objective?
                    "Objective: " + answer.objective.tr(",\n", " ") + "\r" + "Answer: " + answer.answer.tr(",\n", " ")
                  end
                line << answer_text
              end

              csv << line


            end
          end

        end

      end
    end
  end
end
