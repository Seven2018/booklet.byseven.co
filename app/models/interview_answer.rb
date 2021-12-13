class InterviewAnswer < ApplicationRecord
  belongs_to :interview
  belongs_to :interview_question
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:interview_id, :interview_question_id] }
end
