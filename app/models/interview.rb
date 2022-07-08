class Interview < ApplicationRecord
  belongs_to :campaign
  belongs_to :interview_form
  belongs_to :employee, class_name: "User"
  belongs_to :interviewer, class_name: "User"
  belongs_to :creator, class_name: "User"
  has_many :interview_answers, dependent: :destroy
  validates :title, :label, presence: true
  validate :single_campaign_interview_set_per_employee
  validate :label_and_interview_form_match
  validate :not_locked

  alias answers interview_answers

  enum status: {
    not_started: 0,
    not_available_yet: 10,
    in_progress: 20,
    submitted: 30
  }

  serialize :archived_for, Hash

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

  scope :submitted, -> { where(status: :submitted) }
  scope :locked, -> { where.not(locked_at: nil) }
  scope :employee_label, -> { where(label: 'Employee') }
  scope :manager_label, -> { where(label: 'Manager') }

  def set
    @set ||= Poro::Campaign.new(campaign: campaign, employee_id: employee_id)
  end

  def responder
    return employee if employee?
    return interviewer if manager? || crossed?

    raise StandardError
  end

  def fully_answered?
    interview_answers
      .where_exists(:interview_question, required_for: ["#{self.label == 'Employee' ? 'employee' : 'manager'}", "all"])
      .count >= interview_questions.not_separator
                  .required_for(self.label == 'Employee' ? 'employee' : 'manager')
                  .count

  end

  def last_updated?
    self.interview_answers.order(updated_at: :desc).first.updated_at.strftime('%d %b, %Y')
  end

  def submit!
    return unless fully_answered?

    update status: :submitted
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
    self.update(locked_at: Time.zone.now)
  end

  def unlock!
    update_columns locked_at: nil
  end

  def locked?
    locked_at.present? && !will_save_change_to_locked_at?
  end

  def update_archived_for(name, value)
    archived_for[name] = value
    update_column(:archived_for, archived_for)
  end

  private

  def single_campaign_interview_set_per_employee
    errors.add(:base, 'only one interview per campaign per employee per label') if
      campaign.interviews.where(label: label, employee: employee)
                         .where.not(id: id)
                         .exists?
  end

  VALID_LABELS = {
    answerable_by_employee_not_crossed: %w[Employee],
    answerable_by_manager_not_crossed: %w[Manager],
    answerable_by_both_not_crossed: %w[Manager Employee],
    answerable_by_both_crossed: %w[Manager Employee Crossed]
    # temp TODO harmonize legacy Simple start
    # answerable_by_manager_not_crossed: %w[Manager Simple],
    # answerable_by_both_not_crossed: %w[Manager Simple Employee],
    # answerable_by_both_crossed: %w[Manager Simple Employee Crossed]
    # temp TODO harmonize legacy Simple end
  }.freeze

  def label_and_interview_form_match
    return if campaign.simple? || campaign.crossed?

    errors.add(:base, 'mismatch interview label and interview_form kind') unless
      VALID_LABELS[interview_form.kind].include?(label)
  end

  def unlocking
    locked_at.nil? && will_save_change_to_locked_at?
  end

  def not_locked
    errors.add(:base, 'a locked interview can not be changed') if locked? || unlocking
  end
end
