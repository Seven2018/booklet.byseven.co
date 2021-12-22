class Interview < ApplicationRecord
  belongs_to :campaign
  belongs_to :interview_form
  belongs_to :employee, class_name: "User"
  belongs_to :creator, class_name: "User"
  has_many :interview_answers, dependent: :destroy
  validates :title, :label, presence: true
  validate :single_campaign_interview_set_per_employee

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
    interview_answers.count >=
      if self.crossed?
        interview_questions.not_separator.required.count
      else
        interview_questions.not_separator.visible?(self.label == 'Employee' ? 'employee' : 'manager').required.count
      end
  end

  def complete!
    return unless fully_answered?

    update completed: true
  end

  def time
    "#{date} - #{starts_at.strftime("%Hh%M")} => #{ends_at.strftime("%Hh%M")}"
  end

  # TODO replace with enum
  def employee?
    label == 'Employee'
  end

  def manager?
    label == 'Manager'
  end

  def crossed?
    label == 'Crossed'
  end

  def reorder_questions!
    interview_questions.order(position: :asc)
                       .each_with_index do |question, i|
      question.update_columns(position: i + 1)
    end
  end

  private

  def single_campaign_interview_set_per_employee
    errors.add(:base, 'only one interview per campaign per employee per label') if
      campaign.interviews.where(label: label, employee: employee)
                         .where.not(id: id)
                         .exists?
  end
end
