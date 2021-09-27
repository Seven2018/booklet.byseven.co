class UserInterest < ApplicationRecord
  belongs_to :user
  belongs_to :folder, optional: true
  belongs_to :content, optional: true
  # validates_uniqueness_of :content_id, scope: :user_id
  # validates_uniqueness_of :folder_id, scope: :user_id

  include PgSearch::Model
  pg_search_scope :search_recommendations,
    associated_against: {
      content: :title
    },
    using: {
      tsearch: { prefix: true }
    },
    ignoring: :accents
end
