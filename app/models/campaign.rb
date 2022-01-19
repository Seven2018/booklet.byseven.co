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
end
