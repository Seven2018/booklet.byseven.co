class Category < ApplicationRecord
  has_many :content_categories, dependent: :destroy
  has_many :contents, through: :content_categories
end
