class Company < ApplicationRecord
  has_many :users
  has_many :training_programs
  has_many :workshops
end
