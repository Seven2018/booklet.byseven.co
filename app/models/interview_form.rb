class InterviewForm < ApplicationRecord
  has_many :interview_questions, dependent: :destroy
  has_many :interviews
  has_many :employees, through: :interviews
  has_many :interview_form_tags, dependent: :destroy
  has_many :tags, through: :interview_form_tags
  has_many :campaigns

  include PgSearch::Model
  pg_search_scope :search_templates,
    against: [ :title ],
    associated_against: {
      tags: :tag_name,
      employees: [:lastname, :firstname]
    },
    using: {
      tsearch: { prefix: true }
    },
    ignoring: :accents
end