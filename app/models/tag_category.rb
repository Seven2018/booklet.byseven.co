class TagCategory < ApplicationRecord
  has_many :tags, dependent: :destroy
  has_many :user_tags, dependent: :destroy
  belongs_to :company
  validates :name, presence: true
end
