class TrainingWorkshop < ApplicationRecord
  belongs_to :training, optional: true
  belongs_to :workshop
  has_many :attendees, dependent: :destroy
  has_many :users, through: :attendees
  has_many :team_workshops, dependent: :destroy
  has_many :teams, through: :team_workshops
  has_many :training_workshop_mods, dependent: :destroy
  has_many :mods, through: :training_workshop_mods
  validate :end_date_after_start_date

  def start_time
    self.date
  end

  def end_date_after_start_date
    status = true
    return status if available_date.blank?

    if available_date > date
      errors.add(:available_date, "must be after the start date")
      status = false
    end
    status
  end
end
