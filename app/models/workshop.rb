class Workshop < ApplicationRecord
  belongs_to :content
  has_one :session
  has_many :mods, dependent: :destroy
  has_many :assessments, dependent: :destroy
  validates :title, :duration, presence: true
end
