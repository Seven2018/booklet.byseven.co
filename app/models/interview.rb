class Interview < ApplicationRecord
  belongs_to :campaign
  belongs_to :interview_form
  belongs_to :employee, class_name: "User"
  belongs_to :creator, class_name: "User"
  has_many :interview_answers

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
end
