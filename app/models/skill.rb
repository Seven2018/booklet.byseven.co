class Skill < ApplicationRecord
  has_many :user_skills, dependent: :destroy
  has_many :users, through: :user_skills
  has_many :workshop_skills, dependent: :destroy
  has_many :workshops, through: :workshop_skills
  has_many :training_program_skills, dependent: :destroy
end
