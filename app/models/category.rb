class Category < ApplicationRecord
  has_many :workshop_categories, dependent: :destroy
  has_many :workshops, through: :workshop_categories
  has_many :program_categories, dependent: :destroy
  has_many :training_programs, through: :program_categories
end
