class Company < ApplicationRecord
  has_many :users
  has_many :contents
  has_many :trainings
  has_many :sessions
  has_many :tag_categories, dependent: :destroy
  has_many :interview_reports, dependent: :destroy
  has_many :campaigns, dependent: :destroy

  validates :siret, presence: true, length: { is: 14 }
  validates :siret, uniqueness: true
end
