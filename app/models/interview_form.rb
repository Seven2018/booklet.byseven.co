class InterviewForm < ApplicationRecord
  class UnknownKind < StandardError; end
  has_many :interview_questions, dependent: :destroy
  has_many :interviews
  has_many :employees, through: :interviews
  has_many :interview_form_tags, dependent: :destroy
  has_many :tags, through: :interview_form_tags
  has_and_belongs_to_many :categories
  belongs_to :company

  validates :title, presence: true

  paginates_per 10

  enum answerable_by: {
    both: 0,
    manager: 10,
    employee: 20,
  }, _prefix: true

  include PgSearch::Model
  pg_search_scope :search_templates,
    against: [ :title ],
    associated_against: {
      tags: :tag_name
    },
    using: {
      tsearch: { prefix: true }
    },
    ignoring: :accents

  scope :unused, -> { where(used: false) }

  def kind
    case
    when answerable_by_manager? && !cross  then :answerable_by_manager_not_crossed
    when answerable_by_employee? && !cross then :answerable_by_employee_not_crossed
    when answerable_by_both? && !cross     then :answerable_by_both_not_crossed
    when answerable_by_both? && cross      then :answerable_by_both_crossed
    else
      raise UnknownKind
    end
  end
end
