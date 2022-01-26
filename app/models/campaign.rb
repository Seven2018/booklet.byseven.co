require 'csv'

class Campaign < ApplicationRecord
  class AmbiguousInterviewQuery < StandardError; end

  belongs_to :company
  belongs_to :owner, class_name: "User"
  belongs_to :interview_form
  has_many :interviews, dependent: :destroy
  has_many :employees, through: :interviews

  validates :title, presence: true

  enum campaign_type: {
    simple: 0,
    crossed: 10,
  }, _prefix: true

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

  def crossed?
    self.campaign_type_crossed?
  end

  def simple?
    self.campaign_type_simple?
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

  def hr_interview(employee_id = nil)
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
      hr_interview = interviews.find(&:manager?)
      employee_interview = interviews.find(&:employee?)
      crossed_interview = interviews.find(&:crossed?)
      {
        employee_id: employee.id,
        employee_email: employee.email,
        interviews: {
          hr_interview: {
            interview_id: hr_interview.id,
            answers_count: hr_interview.answers.count,
            completed: hr_interview.completed,
            locked_at: hr_interview.locked_at
          },
          employee_interview: {
            interview_id: employee_interview.id,
            answers_count: employee_interview.answers.count,
            completed: employee_interview.completed,
            locked_at: employee_interview.locked_at
          },
          crossed_interview: {
            interview_id: crossed_interview.id,
            answers_count: crossed_interview.answers.count,
            completed: crossed_interview.completed,
            locked_at: crossed_interview.locked_at
          }
        }
      }
    end

    {
      owner_id: owner.id,
      owner_email: owner.email,
      data: data
    }
  end

  def self.to_csv(company_id)

    tag_categories = TagCategory.where(company_id: company_id).order(position: :asc)

    columns = ['Campaign ID',
        'Campaign Title',
        'Campaign Type',
        'Campaign URL',
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

        campaign.employees.distinct.each do |employee|
          campaign_url = 'https://seven-booklet.herokuapp.com/campaigns/' + campaign_id.to_s + '?employee_id=' + employee.id.to_s
          employee_interviews = campaign.interviews.where(employee_id: employee.id)

          interview =
            if campaign.simple?
              employee_interviews.first
            elsif campaign.crossed?
              employee_interviews.find_by(label: 'Crossed')
            end

          line = []
          line << campaign_id
          line << campaign_title
          line << campaign_type
          line << campaign_url
          line << campaign_employees_count
          line << owner_email
          line << owner_fullname
          line << employee.email
          line << employee.fullname
          line << employee.job_title
          line << campaign.completion_for(employee)
          line << interview.locked_at
          line << interview.time.split(' - ').first
          tag_categories.each do |tag_category|
            tag = UserTag.find_by(tag_category_id: tag_category.id, user_id: employee.id)
            tag = tag.present? ? tag.tag.tag_name : ''
            line << tag
          end
          interview.interview_questions.order(position: :asc).each do |question|
            answer = question.interview_answers.find_by(interview_id: interview.id, user_id: employee.id)
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
