class Session < ApplicationRecord
  belongs_to :training, optional: true
  belongs_to :company
  belongs_to :content
  has_many :attendees
end
