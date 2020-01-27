class Mod < ApplicationRecord
  has_many :workshop_mods, dependent: :destroy
  has_many :training_workshop_mods, dependent: :destroy
end
