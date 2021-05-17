class Content < ApplicationRecord
  belongs_to :company
  belongs_to :category
  belongs_to :author, class_name: 'User', optional: true
  belongs_to :folder, optional: true
  has_many :content_skills, dependent: :destroy
  has_many :skills, through: :content_skills
  has_many :mods
  has_many :assessments, dependent: :destroy
  validates :title, :duration, presence: true
  has_rich_text :description
end
