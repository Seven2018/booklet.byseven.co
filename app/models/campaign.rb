class Campaign < ApplicationRecord
  belongs_to :company
  belongs_to :owner, class_name: "User"
  belongs_to :interview_form
  has_many :interviews, dependent: :destroy
  has_many :employees, through: :interviews

  def completion_for(employee = nil)
    return (interviews.completed.count.fdiv(interviews.count) * 100).round if employee == :all

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
end
