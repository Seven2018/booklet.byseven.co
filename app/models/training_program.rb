class TrainingProgram < ApplicationRecord
  belongs_to :company, optional: true
  belongs_to :author, class_name: 'User', optional: true
  has_many :trainings
  has_many :program_workshops, dependent: :destroy
  has_many :workshops, through: :program_workshops
  has_many :requests, dependent: :destroy
  has_many :program_categories, dependent: :destroy
  has_many :categories, through: :program_categories
end
