class InterviewAnswer < ApplicationRecord
  belongs_to :interview
  belongs_to :interview_question
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:interview_id, :interview_question_id] }
  validate :interview_not_locked
  delegate :locked?, to: :interview

  private

  def interview_not_locked
    errors.add(:base, 'an answer can not be changed once its interview is locked') if locked?
  end
end
