class Tag < ApplicationRecord
  has_many :user_tags, dependent: :destroy
  has_many :users, through: :user_tags
  has_many :tag_workshops, dependent: :destroy
  has_many :training_workshops, through: :tag_workshops
  belongs_to :company
  belongs_to :tag_category
end
