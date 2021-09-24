class UserInterest < ApplicationRecord
  belongs_to :user
  belongs_to :folder, optional: true
  belongs_to :content, optional: true
  validates_uniqueness_of :content_id, scope: :user_id
  validates_uniqueness_of :folder_id, scope: :user_id
end
