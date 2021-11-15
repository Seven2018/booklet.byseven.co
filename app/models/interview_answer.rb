class InterviewAnswer < ApplicationRecord
  belongs_to :interview_question
  belongs_to :user
end
