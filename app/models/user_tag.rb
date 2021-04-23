class UserTag < ApplicationRecord
  belongs_to :user
  belongs_to :tag
  validates_uniqueness_of :tag_id, scope: :user_id
end
