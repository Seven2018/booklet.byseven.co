class Interview < ApplicationRecord
  belongs_to :campaign
  belongs_to :interview_form
  belongs_to :employee, class_name: "User"
  belongs_to :creator, class_name: "User"
  has_many :interview_answers, dependent: :destroy
  before_create :ensure_date_presence
  validates :title, :label, presence: true
  validate :single_campaign_interview_set_per_employee
  validate :not_locked

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
      if self.crossed? || self.simple?
        interview_questions.not_separator.required.count
      else
        interview_questions.not_separator.visible?(self.label == 'Employee' ? 'employee' : 'manager').required.count
      end
  end

  def last_updated?
    self.interview_answers.order(updated_at: :desc).first.updated_at.strftime('%d/%m/%Y')
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

  def simple?
    label == 'Simple'
  end

  def reorder_questions!
    interview_questions.order(position: :asc)
                       .each_with_index do |question, i|
      question.update_columns(position: i + 1)
    end
  end

  def lock!
    campaign.interviews.where(employee: employee).update(locked_at: Time.zone.now)
  end

  def locked?
    locked_at.present? && !will_save_change_to_locked_at?
  end

  private

  def single_campaign_interview_set_per_employee
    errors.add(:base, 'only one interview per campaign per employee per label') if
      campaign.interviews.where(label: label, employee: employee)
                         .where.not(id: id)
                         .exists?
  end

  def unlocking
    locked_at.nil? && will_save_change_to_locked_at?
  end

  def not_locked
    errors.add(:base, 'a locked interview can not be changed') if locked? || unlocking
  end

  def ensure_date_presence
    return if date.present?

    self.date = Time.zone.today.end_of_month
  end
end
