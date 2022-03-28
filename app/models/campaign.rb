require 'csv'

class Campaign < ApplicationRecord
  include Campaigns::Stats
  class AmbiguousInterviewQuery < StandardError; end

  belongs_to :company
  belongs_to :owner, class_name: "User"
  belongs_to :interview_form, optional: true
  has_many :interviews, dependent: :destroy
  has_many :employees, through: :interviews
  has_many :interviewers, through: :interviews

  validates :title, presence: true

  paginates_per 10

  enum campaign_type: {
    simple: 0,
    crossed: 10,
    one_to_one: 20,
    feedback_360: 30
  }

  include PgSearch::Model
  pg_search_scope :search_campaigns,
    against: [ :title ],
    associated_against: {
      owner: [:lastname, :firstname, :email],
      employees: [:lastname, :firstname, :email]
    },
    using: {
      tsearch: { prefix: true }
    },
    ignoring: :accents

  alias :manager :owner

  def deadline
    interviews.order(date: :asc).first.date
  end

  def interview_sets
    @interview_sets ||=
      employees.distinct.ids.map { |employee_id| interviews.find_by(employee_id: employee_id).set }
  end

  def interview_forms
    interviews.map{|x| x.interview_form}.uniq
  end

  def completion_for(employee)
    return 0 if interviews.count.zero?

    return (interviews.completed.count.fdiv(interviews.count) * 100).round if employee == :all

    return 0 if interviews.where(employee: employee).count.zero?

    (
      interviews.completed.where(employee: employee).count
      .fdiv(interviews.where(employee: employee).count) * 100
    ).round
  end

  def manager_interview(employee_id = nil)
    if interviews.select(&:manager?).count == 1
      return interviews.find(&:manager?)
    end

    raise AmbiguousInterviewQuery unless employee_id

    interviews.where(employee_id: employee_id).find(&:manager?)
  end

  def employee_interview(employee_id = nil)
    if interviews.select(&:employee?).count == 1
      return interviews.find(&:employee?)
    end

    raise AmbiguousInterviewQuery unless employee_id

    interviews.where(employee_id: employee_id).find(&:employee?)
  end

  def crossed_interview(employee_id = nil)
    if interviews.select(&:crossed?).count == 1
      return interviews.find(&:crossed?)
    end

    raise AmbiguousInterviewQuery unless employee_id

    interviews.where(employee_id: employee_id).find(&:crossed?)
  end

  def self.to_csv_analytics(company_id, tag_category_id)
    tag_category = TagCategory.find(tag_category_id)

    columns = [tag_category.name,
        'Employees count',
        'Interviews sets - Total',
        'Interviews sets - Completed',
        'Interviews sets - Locked',
        'Interviews sets - In progress',
        'Interviews sets - Not started',
        'Interviews sets - Completed/Total',
        'Interviews sets - Locked/Total',
        'Interviews sets - In Progress/Total',
        'Interviews sets - Not Started/Total',
        'Interviews sets - Started Total'
        ]

    CSV.generate(headers: true) do |csv|
      csv << columns
      tag_category.tags.order(tag_name: :asc).each do |tag|
        employees = User.where(company_id: company_id).where_exists(:user_tags, tag_id: tag.id)

        analytics_hash = {}
        employees.each{|x| analytics_hash[x.id] = []}

        campaigns_detes = all.where(company_id: company_id).map{|x| x.interviews.group_by(&:employee_id)}
        campaigns_detes.each{|x| x.each{|y,z| analytics_hash[y] << z if analytics_hash.key?(y)}}

        interviews_sets_total = 0
        interviews_sets_completed = 0
        interviews_sets_locked = 0
        interviews_sets_not_started = 0
        analytics_hash.each{|x, y| interviews_sets_total += y.count;
                              interviews_sets_completed += y.map{|z| z.map{|z1| z1.completed && z1.locked_at.nil?}.uniq == [true]}.select(&:itself).count;
                              interviews_sets_locked += y.map{|z| z.map{|z1| z1.locked_at.present?}.uniq == [true]}.select(&:itself).count;
                              interviews_sets_not_started += y.map{|z| z.map{|z1| z1.completed}.uniq == [false]}.select(&:itself).count;
                            }
        employees_count = 0
        analytics_hash.each{|x,y| employees_count += 1 if y.count > 0}

        interviews_sets_in_progress = interviews_sets_total - interviews_sets_locked - interviews_sets_completed - interviews_sets_not_started
        interviews_sets_completed_by_total = interviews_sets_total > 0 ? (interviews_sets_completed.fdiv(interviews_sets_total)*100).round : 0
        interviews_sets_locked_by_total = interviews_sets_total > 0 ? (interviews_sets_locked.fdiv(interviews_sets_total)*100).round : 0
        interviews_sets_not_started_by_total = interviews_sets_total > 0 ? (interviews_sets_not_started.fdiv(interviews_sets_total)*100).round : 0
        interviews_sets_in_progress_by_total = interviews_sets_total > 0 ? (interviews_sets_in_progress.fdiv(interviews_sets_total)*100).round : 0
        interviews_set_total_ongoing = interviews_sets_in_progress_by_total + interviews_sets_completed_by_total + interviews_sets_locked_by_total

        line = []

        line << tag.tag_name
        line << employees_count
        line << interviews_sets_total
        line << interviews_sets_completed
        line << interviews_sets_locked
        line << interviews_sets_in_progress
        line << interviews_sets_not_started
        line << interviews_sets_completed_by_total.to_s + '%'
        line << interviews_sets_locked_by_total.to_s + '%'
        line << interviews_sets_in_progress_by_total.to_s + '%'
        line << interviews_sets_not_started_by_total.to_s + '%'
        line << interviews_set_total_ongoing.to_s + '%'

        csv << line
      end
    end
  end

  def self.to_csv_data(company_id)

    tag_categories = TagCategory.where(company_id: company_id).where.not(name: 'Job Title').order(position: :asc)

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
      all.each do |campaign|

        campaign_id = campaign.id
        campaign_title = campaign.title
        campaign_type = campaign.campaign_type

        campaign.interviews.each do |interview|
          employee = interview.employee
          next unless employee # should NOT happen

          interviewer = interview.interviewer
          interviewer_email = interviewer.email
          interviewer_fullname = interviewer.fullname

          campaign_url = 'https://booklet.byseven.co/campaigns/' + campaign_id.to_s + '?employee_id=' + employee.id.to_s

          line = []
          line << campaign_id
          line << campaign_title
          line << campaign_url
          line << campaign_type
          line << interview.label
          line << interviewer_email
          line << interviewer_fullname
          line << employee.email
          line << employee.fullname
          line << employee.job_title
          line << campaign.completion_for(employee)
          line << interview.locked_at
          line << interview.date
          tag_categories.each do |tag_category|
            tag = UserTag.find_by(tag_category_id: tag_category.id, user_id: employee.id)
            tag = tag.present? ? tag.tag.tag_name : ' '
            line << tag
          end
          csv << line
        end
      end
    end
  end

  def to_csv_answers(interview_form_id)
    employees = Interview.where(campaign: self, interview_form_id: interview_form_id).map(&:employee).uniq
    interview_form = InterviewForm.find(interview_form_id)
    tag_categories = TagCategory.where(company_id: company_id).order(position: :asc)

    columns = ['Interview Type',
        'Interview Label',
        'Interviewer email',
        'Interviewer fullname',
        'Interviewee email',
        'Interviewee fullname'] +
        tag_categories.map(&:name) +
        ['Deadline'] +
        interview_form.interview_questions.where.not(question_type: 'separator').order(position: :asc).map(&:question)

    CSV.generate(headers: true) do |csv|
      csv << columns

      employees.sort_by{|x| x.lastname}.each do |employee|

        employee_id = employee.id
        employee_email = employee.email
        employee_fullname = employee.fullname
        employee_tags = employee.tags.order(tag_category_position: :asc).map(&:tag_name)

        interviews_set = [self.employee_interview(employee_id), self.manager_interview(employee_id), self.crossed_interview(employee_id)].compact

        interview_type =
          if interviews_set.count == 1
            interview_set.first.label
          elsif interviews_set.count == 2
            'Both'
          else
            'Cross'
          end

        interviewer = interviews_set.first.interviewer
        interviewer_email = interviewer.email
        interviewer_fullname = interviewer.fullname
        deadline = interviews_set.first.date

        interviews_set.each do |interview|

          line = []
          interview_label = interview.label

          line << interview_type
          line << interview_label
          line << interviewer_email
          line << interviewer_fullname
          line << employee_email
          line << employee_fullname
          employee_tags.each{|tag| line << tag}
          line << deadline

          interview.interview_questions.order(position: :asc).each do |question|
            answer = question.interview_answers.find_by(interview: interview, user: employee)
            next if answer.nil?
            answer_text =
              if question.rating?
                'Answer: ' + answer.answer + '/' + question.options.keys.first
              elsif question.open_question? || question.mcq?
                'Answer: ' + answer.answer
              elsif question.objective?
                'Objective: ' + answer.objective + "\r" + 'Answer: ' + answer.answer
              end
            line << answer_text
          end

          csv << line


        end
      end

    end
  end
end
