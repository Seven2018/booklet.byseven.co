class Session < ApplicationRecord
  belongs_to :training
  belongs_to :workshop, dependent: :destroy
  has_many :attendees, dependent: :destroy
  has_many :users, through: :attendees

  scope :with_date, -> { where.not(date: nil) }

  def duration
    ends_at - starts_at
  end

  def start_date
    self.date
  end

  def end_date
    self.available_date.present? ? self.available_date : self.date
  end
end

