class Team < ApplicationRecord
  has_many :user_teams, dependent: :destroy
  has_many :users, through: :user_teams
  has_many :team_categories, dependent: :destroy
  has_many :categories, through: :team_categories
  belongs_to :company
end
