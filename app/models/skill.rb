class Skill < ApplicationRecord
  has_many :user_skills, dependent: :destroy
  has_many :users, through: :user_skills
  has_many :workshop_skills, dependent: :destroy
  has_many :workshops, through: :workshop_skills
  belongs_to :skill_group
end
