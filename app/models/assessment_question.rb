class AssessmentQuestion < ApplicationRecord
  belongs_to :assessment
  has_many :assessment_options, dependent: :destroy
end
