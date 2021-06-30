class Company < ApplicationRecord
  has_many :users
  has_many :contents
  has_many :trainings
  has_many :sessions
  validates :siret, presence: true, length: { is: 14 }
  validates :siret, uniqueness: true
end
