class Content < ApplicationRecord
  belongs_to :company
  belongs_to :author, class_name: 'User', optional: true
  belongs_to :folder, optional: true
  has_many :content_categories, dependent: :destroy
  has_many :categories, through: :content_categories
  has_many :content_skills, dependent: :destroy
  has_many :skills, through: :content_skills
  has_many :mods, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :assessments, dependent: :destroy
  has_many :user_interests, dependent: :destroy
  has_many :interested, through: :user_interests, source: :user
  validates :title, :duration, presence: true
  serialize :recommended, Array
end