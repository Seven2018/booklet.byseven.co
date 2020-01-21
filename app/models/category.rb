class Category < ApplicationRecord
  has_many :workshop_categories, dependent: :destroy
  has_many :workshops, through: :workshop_categories
end
