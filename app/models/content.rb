class Content < ApplicationRecord
  belongs_to :company
  belongs_to :folder, optional: true
  has_many :content_categories, dependent: :destroy
  has_many :categories, through: :content_categories
  has_many :content_skills, dependent: :destroy
  has_many :skills, through: :content_skills
  has_many :mods, dependent: :destroy
  has_many :workshops
  has_many :assessments, dependent: :destroy
  has_many :user_interests, dependent: :destroy
  has_many :interested, through: :user_interests, source: :user
  has_many :content_folder_links, dependent: :destroy
  has_many :folders, through: :content_folder_links
  validates :title, :duration, presence: true

  include PgSearch::Model
  pg_search_scope :search,
    against: [ :title ],
    associated_against: {
      categories: :title
    },
    using: {
      tsearch: { prefix: true }
    },
    ignoring: :accents,
    order_within_rank: "contents.updated_at DESC"

end
