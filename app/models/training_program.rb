class TrainingProgram < ApplicationRecord
  belongs_to :company, optional: true
  has_many :trainings
  has_many :program_workshops, dependent: :destroy
  has_many :workshops, through: :program_workshops
  has_many :training_program_skills, dependent: :destroy
  has_many :requests, dependent: :destroy
end
