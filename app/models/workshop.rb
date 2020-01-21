class Workshop < ApplicationRecord
  belongs_to :company
  has_many :program_workshops, dependent: :destroy
  has_many :programs, through: :program_workshops
  has_many :training_workshops, dependent: :destroy
  has_many :trainings, through: :training_workshops
  has_many :workshop_skills, dependent: :destroy
  has_many :skills, through: :workshop_skills
  has_many :workshop_categories, dependent: :destroy
  has_many :categories, through: :workshop_categories
  accepts_nested_attributes_for :workshop_categories
end
