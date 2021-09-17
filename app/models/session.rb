class Session < ApplicationRecord
  belongs_to :training
  belongs_to :workshop
  has_many :attendees, dependent: :destroy
  has_many :users, through: :attendees
  validates :date, presence: true

  def start_date
    self.date
  end

  def end_date
    self.available_date.present? ? self.available_date : self.date
  end
end

