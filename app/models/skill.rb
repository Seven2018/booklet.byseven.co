class Skill < ApplicationRecord
  has_many :user_skills, dependent: :destroy
  has_many :users, through: :user_skills
  has_many :content_skills, dependent: :destroy
  has_many :contents, through: :content_skills
  belongs_to :skill_group
end
