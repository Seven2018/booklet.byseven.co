class Session < ApplicationRecord
  belongs_to :training, optional: true
  belongs_to :company
  belongs_to :content
  has_many :attendees, dependent: :destroy
  has_many :users, through: :attendees
end

def start_time
  self.date
end

def end_time
  self.date
end
