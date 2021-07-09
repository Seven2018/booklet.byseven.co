class Attendee < ApplicationRecord
  belongs_to :user
  belongs_to :session
  belongs_to :creator, class_name: 'User', optional: true
  validates :session_id, uniqueness: { scope: :user_id }
end
