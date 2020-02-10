class TrainingWorkshop < ApplicationRecord
  belongs_to :training, optional: true
  belongs_to :workshop
  has_many :attendees, dependent: :destroy
  has_many :users, through: :attendees
  has_many :attendee_teams, dependent: :destroy
  has_many :teams, through: :attendee_teams
  has_many :team_workshops, dependent: :destroy
  has_many :teams, through: :team_workshops
  has_many :training_workshop_mods, dependent: :destroy
  has_many :mods, through: :training_workshop_mods
  validate :end_date_after_start_date

  def team_ids
    teams = []
    self.users.map(&:teams).each do |team|
      if team.first.users.count == self.users.joins(:user_teams).where(user_teams: {team_id: team}).count
        teams << team
      end
    end
    teams.flatten(1).uniq.map(&:id)
  end

  def start_time
    self.date
  end

  def end_date_after_start_date
    status = true
    return status if available_date.blank?

    if available_date.present? && available_date < date
      errors.add(:available_date, "must be after the start date")
      status = false
    end
    status
  end
end
