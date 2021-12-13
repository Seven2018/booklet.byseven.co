class Interview < ApplicationRecord
  belongs_to :campaign
  belongs_to :interview_form
  belongs_to :employee, class_name: "User"
  belongs_to :creator, class_name: "User"
  has_many :interview_answers
  alias answers interview_answers

  include PgSearch::Model
  pg_search_scope :search_interviews,
    against: [ :title ],
    associated_against: {
      employee: [:lastname, :firstname]
    },
    using: {
      tsearch: { prefix: true }
    },
    ignoring: :accents

  delegate :interviews, :owner, to: :campaign
  delegate :interview_questions, to: :interview_form

  scope :completed, -> { where(completed: true) }

  def fully_answered?
    interview_answers.count >= interview_questions.not_separator.required.count
  end

  def complete!
    return unless fully_answered?

    update completed: true
  end

  # TODO replace with enum
  def employee?
    label == 'Employee'
  end

  def hr?
    label == 'HR'
  end
  alias manager? hr?

  def crossed?
    label == 'Crossed'
  end

  def reorder_questions!
    interview_questions.order(position: :asc)
                       .each_with_index do |question, i|
      question.update_columns(position: i + 1)
    end
  end
end
