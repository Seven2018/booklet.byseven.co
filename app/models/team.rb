class Team < ApplicationRecord
  has_many :user_teams, dependent: :destroy
  has_many :users, through: :user_teams
  has_many :team_categories, dependent: :destroy
  has_many :categories, through: :team_categories
  has_many :team_workshops, dependent: :destroy
  has_many :training_workshops, through: :team_workshops
  has_many :attendee_teams, dependent: :destroy
  has_many :training_workshops, through: :attendee_teams
  belongs_to :company
end
