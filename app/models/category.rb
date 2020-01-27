class Category < ApplicationRecord
  has_many :workshop_categories, dependent: :destroy
  has_many :workshops, through: :workshop_categories
  has_many :program_categories, dependent: :destroy
  has_many :training_programs, through: :program_categories
  has_many :team_categories, dependent: :destroy
  has_many :teams, through: :team_categories
end
