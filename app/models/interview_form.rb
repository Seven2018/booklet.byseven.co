class InterviewForm < ApplicationRecord
  has_many :interview_questions, dependent: :destroy
  has_many :interviews
  has_many :employees, through: :interviews
  has_many :interview_form_tags, dependent: :destroy
  has_many :tags, through: :interview_form_tags
  has_many :campaigns

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
end
