class AssessmentAnswer < ApplicationRecord
  belongs_to :assessment_question
  belongs_to :user
end
