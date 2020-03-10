class Assessment < ApplicationRecord
  belongs_to :mod
  has_many :assessment_questions, dependent: :destroy
end
