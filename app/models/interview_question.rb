class InterviewQuestion < ApplicationRecord
  belongs_to :interview_form
  has_many :interview_answers, dependent: :destroy
  serialize :options,Hash
end
