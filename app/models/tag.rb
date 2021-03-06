class Tag < ApplicationRecord
  has_many :user_tags, dependent: :destroy
  has_many :users, through: :user_tags
  belongs_to :company
  belongs_to :tag_category
  validates :tag_name, presence: true
  validates_uniqueness_of :tag_name, scope: :tag_category_id
end
