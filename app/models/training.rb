class Training < ApplicationRecord
  belongs_to :training_program, optional: true
  has_many :attendees, dependent: :destroy
  has_many :training_workshops, dependent: :destroy
  has_many :workshops, through: :training_workshops
end
