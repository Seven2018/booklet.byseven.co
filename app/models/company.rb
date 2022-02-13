class Company < ApplicationRecord
  has_many :users
  has_many :contents
  has_many :trainings
  has_many :sessions
  has_many :csv_exports, dependent: :destroy

  validates :siret, presence: true, length: { is: 14 }
  validates :siret, uniqueness: true
end
