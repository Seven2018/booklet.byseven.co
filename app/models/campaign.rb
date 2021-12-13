class Campaign < ApplicationRecord
  belongs_to :company
  belongs_to :owner, class_name: "User"
  belongs_to :interview_form
  has_many :interviews, dependent: :destroy
  has_many :employees, through: :interviews

  def completion_for(employee = nil)
    return (interviews.completed.count.fdiv(interviews.count) * 100).round if employee == :all

    return 0 if interviews.where(employee: employee).count.zero?

    (
      interviews.completed.where(employee: employee).count
      .fdiv(interviews.where(employee: employee).count) * 100
    ).round
  end

  def hr_interview
    interviews.find(&:hr?)
  end

  def employee_interview
    interviews.find(&:employee?)
  end

  def crossed_interview
    interviews.find(&:crossed?)
  end

  def stats
    {
      hr_interview: {
        interview_id: hr_interview.id,
        answers_count: hr_interview.answers.count,
        completed: hr_interview.completed
      },
      employee_interview: {
        interview_id: employee_interview.id,
        answers_count: employee_interview.answers.count,
        completed: employee_interview.completed
      },
      crossed_interview: {
        interview_id: crossed_interview.id,
        answers_count: crossed_interview.answers.count,
        completed: crossed_interview.completed
      }
    }
  end
end
