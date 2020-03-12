class AssessmentQuestion < ApplicationRecord
  belongs_to :mod
  has_many :assessment_answers, dependent: :destroy
  serialize :answer,Hash
  serialize :options,Hash
end
