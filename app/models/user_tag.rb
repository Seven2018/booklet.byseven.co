class UserTag < ApplicationRecord
  belongs_to :user
  belongs_to :tag
  belongs_to :tag_category
  validates_uniqueness_of :tag_category_id, scope: :user_id
end
