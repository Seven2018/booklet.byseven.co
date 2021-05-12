class Workshop < ApplicationRecord
  belongs_to :company
  belongs_to :author, class_name: 'User', optional: true
  has_many :training_workshops, dependent: :destroy
  has_many :workshop_skills, dependent: :destroy
  has_many :skills, through: :workshop_skills
  has_many :workshop_categories, dependent: :destroy
  has_many :categories, through: :workshop_categories
  has_many :workshop_mods, dependent: :destroy
  has_many :mods, through: :workshop_mods
  has_many :assessments, dependent: :destroy
  accepts_nested_attributes_for :workshop_categories
  has_rich_text :description
end
