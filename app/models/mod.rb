class Mod < ApplicationRecord
  has_many :workshop_mods, dependent: :destroy
  has_many :training_workshop_mods, dependent: :destroy
  has_many :assessment_questions, dependent: :destroy
  has_many :user_forms, dependent: :destroy
  has_many :mods, through: :user_forms
end
