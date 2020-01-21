class SkillGroup < ApplicationRecord
  has_many :skills, dependent: :nullify
end
