class Mod < ApplicationRecord
  has_many :workshop_mods, dependent: :destroy
  has_many :workshops, through: :workshop_mods
  has_many :training_workshop_mods, dependent: :destroy
  has_many :training_workshops, through: :training_workshop_mods
  has_many :assessment_questions, dependent: :destroy
  has_many :user_forms, dependent: :destroy
end
