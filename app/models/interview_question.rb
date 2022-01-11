class InterviewQuestion < ApplicationRecord
  belongs_to :interview_form
  acts_as_list scope: :interview_form
  has_many :interview_answers, dependent: :destroy
  serialize :options,Hash

  has_rich_text :description

  scope :not_separator, -> { where.not(question_type: 'separator') }
  scope :required, -> { where(required: true) }

  enum visible_for: {
    all: 0,
    manager: 10,
    employee: 20,
  }, _prefix: true

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

  def self.visible?(option)
    if option == 'employee'
      # ['all', 'employee'].include?(visible_for)
      self.where(visible_for: ['all', 'employee'])
    else
      # ['all', 'manager'].include?(visible_for)
      self.where(visible_for: ['all', 'manager'])
    end
  end
end
