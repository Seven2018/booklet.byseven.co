require 'csv'

class Campaign < ApplicationRecord
  class AmbiguousInterviewQuery < StandardError; end

  belongs_to :company
  belongs_to :owner, class_name: "User"
  belongs_to :interview_form, optional: true
  has_many :interviews, dependent: :destroy
  has_many :employees, through: :interviews

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

  def stats
    data = interviews.group_by(&:employee_id).map do |employee_id, interviews|
      employee = User.find(employee_id)
      manager_interview = interviews.find(&:manager?)
      employee_interview = interviews.find(&:employee?)
      crossed_interview = interviews.find(&:crossed?)
      simple_interview = interviews.find(&:simple?)
      interviews = {}
      interviews[:manager_interview] = {
        id: manager_interview.id,
        answers_count: manager_interview.answers.count,
        completed: manager_interview.completed,
        locked_at: manager_interview.locked_at
      } if manager_interview

      interviews[:employee_interview] = {
        id: employee_interview.id,
        answers_count: employee_interview.answers.count,
        completed: employee_interview.completed,
        locked_at: employee_interview.locked_at
      } if employee_interview

      interviews[:crossed_interview] = {
        id: crossed_interview.id,
        answers_count: crossed_interview.answers.count,
        completed: crossed_interview.completed,
        locked_at: crossed_interview.locked_at
      } if crossed_interview

      interviews[:simple_interview] = {
        id: simple_interview.id,
        answers_count: simple_interview.answers.count,
        completed: simple_interview.completed,
        locked_at: simple_interview.locked_at
      } if simple_interview

      {
        employee_id: employee.id,
        employee_email: employee.email,
        interviews: interviews
      }
    end

    {
      id: id,
      owner_id: owner.id,
      owner_email: owner.email,
      campaign_type: campaign_type,
      data: data
    }
  end

  def self.to_csv_analytics(company_id, tag_category_id)
    tag_category = TagCategory.find(tag_category_id)

    columns = [tag_category.name,
        'Employees count',
        'Cross Interviews - Completed',
        'Cross Interviews - Locked',
        'Cross Interviews - In progress',
        'Cross Interviews - Not started',
        'Cross Interviews - Employees not set',
        'Cross Interviews - Total',
        'Cross Interviews - Locked/Total',
        'Simple Interviews - Completed',
        'Simple Interviews - Locked',
        'Simple Interviews - Not started',
        'Simple Interviews - Employees not set',
        'Simple Interview - Total',
        'Simple Interviews - Completed/Total'
        ]

    CSV.generate(headers: true) do |csv|
      csv << columns
      tag_category.tags.order(tag_name: :asc).each do |tag|
        employees = User.where(company_id: company_id).where_exists(:user_tags, tag_id: tag.id)
        crossed_total = Interview.where(campaign_id: all.ids, label: 'Crossed', employee_id: employees.ids).count
        crossed_completed = Interview.where(campaign_id: all.ids, label: 'Crossed', employee_id: employees.ids, completed: true, locked_at: nil).count
        crossed_locked = Interview.where(campaign_id: all.ids, label: 'Crossed', employee_id: employees.ids, completed: true).where.not(locked_at: nil).count
        crossed_not_started = Interview.where(campaign_id: all.ids, label: 'Employee', employee_id: employees.ids, completed: false).map{|x| !Interview.find_by(campaign_id: x.campaign_id, label: 'Manager', employee_id: x.employee_id)&.completed?}.count
        crossed_in_progress = crossed_total - crossed_locked - crossed_completed - crossed_not_started
        crossed_not_set = employees.where_not_exists(:interviews, campaign_id: all.ids, employee_id: employees.ids).distinct.count
        # crossed_not_set = employees.count - Interview.where(campaign_id: all.ids, label: 'Crossed', employee_id: employees.ids).count
        crossed_locked_by_total = crossed_total > 0 ? (crossed_locked.fdiv(crossed_total)*100).round.to_s + '%' : '0%'
        simple_completed = Interview.where(campaign_id: all.ids, label: 'Simple', employee_id: employees.ids, completed: true, locked_at: nil).count
        simple_locked = Interview.where(campaign_id: all.ids, label: 'Simple', employee_id: employees.ids).where.not(locked_at: nil).count
        simple_not_started = Interview.where(campaign_id: all.ids, label: 'Simple', employee_id: employees.ids, completed: false).count
        simple_not_set = employees.count - Interview.where(campaign_id: all.ids, label: 'Simple', employee_id: employees.ids).count
        simple_total = Interview.where(campaign_id: all.ids, label: 'Simple', employee_id: employees.ids).count
        simple_completed_by_total = simple_total > 0 ? (simple_completed.fdiv(simple_total)*100).round.to_s + '%' : '0%'

        line = []

        line << tag.tag_name
        line << employees.count
        line << crossed_completed
        line << crossed_locked
        line << crossed_in_progress
        line << crossed_not_started
        line << crossed_not_set
        line << crossed_total
        line << crossed_locked_by_total

        line << simple_completed
        line << simple_locked
        line << simple_not_started
        line << simple_not_set
        line << simple_total
        line << simple_completed_by_total

        csv << line
      end
    end
  end

  def self.to_csv_data(company_id)

    tag_categories = TagCategory.where(company_id: company_id).order(position: :asc)

    columns = ['Campaign ID',
        'Campaign Title',
        'Campaign URL',
        'Campaign Type',
        'Interview Type',
        'Employees Count (per Campaign)',
        'Owner Email',
        'Owner Fullname',
        'Employee Email',
        'Employee Fullname',
        'Employee Job Title',
        'Employee Completion',
        'Interview Locked At',
        'Deadline'] + tag_categories.map(&:name)
    CSV.generate(headers: true) do |csv|
      csv << columns
      all.each do |campaign|

        campaign_id = campaign.id
        campaign_title = campaign.title
        campaign_type = campaign.campaign_type
        campaign_employees_count = campaign.employees.distinct.count
        owner_email = campaign.owner.email
        owner_fullname = campaign.owner.fullname

        campaign.interviews.each do |interview|
          employee = interview.employee
          campaign_url = 'https://booklet.byseven.co/campaigns/' + campaign_id.to_s + '?employee_id=' + employee.id.to_s

          if interview.label == 'Employee'
            user_for_answer = employee
          else
            user_for_answer = campaign.owner
          end

          line = []
          line << campaign_id
          line << campaign_title
          line << campaign_url
          line << campaign_type
          line << interview.label
          line << campaign_employees_count
          line << owner_email
          line << owner_fullname
          line << employee.email
          line << employee.fullname
          line << employee.job_title
          line << campaign.completion_for(employee)
          line << interview.locked_at
          line << interview.date
          tag_categories.each do |tag_category|
            tag = UserTag.find_by(tag_category_id: tag_category.id, user_id: employee.id)
            tag = tag.present? ? tag.tag.tag_name : ''
            line << tag
          end
          interview.interview_questions.order(position: :asc).each do |question|
            answer = question.interview_answers.find_by(interview_id: interview.id, user_id: user_for_answer.id)
            next if answer.nil?
            question_text = "Question: " + question.question + "\n"
            answer_text =
              if question.rating?
                "Answer: " + answer.answer + '/' + question.options.keys.first
              elsif question.open_question? || question.mcq?
                "Answer: " + answer.answer
              elsif question.objective?
                "Objective: " + answer.objective + "\n" + "Answer: " + answer.answer
              end
            line << question_text + answer_text
          end
          csv << line
        end
      end
    end
  end
end
