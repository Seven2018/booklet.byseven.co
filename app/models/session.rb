class Session < ApplicationRecord
  belongs_to :training
  belongs_to :company
  has_many :attendees
end
