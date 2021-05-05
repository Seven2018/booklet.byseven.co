class TagCategory < ApplicationRecord
  has_many :tags, dependent: :destroy
  belongs_to :company
  validates :name, presence: true
end
