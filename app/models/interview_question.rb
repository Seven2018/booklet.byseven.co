class InterviewQuestion < ApplicationRecord
  belongs_to :interview_form
  acts_as_list scope: :interview_form
  has_many :interview_answers, dependent: :destroy
  serialize :options,Hash

  scope :not_separator, -> { where.not(question_type: 'separator') }
  scope :required, -> { where(required: true) }

  # TODO refacto question_type => enum
  # for perf + having below getters out of the box
  def open_question?
    question_type == 'open_question'
  end

  def separator?
    question_type == 'separator'
  end

  def rating?
    question_type == 'rating'
  end

  def mcq?
    question_type == 'mcq'
  end
end
