class Category < ApplicationRecord
  has_many :content_categories, dependent: :destroy
  has_many :contents, through: :content_categories
  has_many :folder_categories, dependent: :destroy
  has_many :folders, through: :folder_categories
  has_and_belongs_to_many :interview_forms, dependent: :destroy
end
