class Session < ApplicationRecord
  belongs_to :training, optional: true
  belongs_to :company
  belongs_to :content
  has_many :attendees, dependent: :destroy
  has_many :users, through: :attendees
end
