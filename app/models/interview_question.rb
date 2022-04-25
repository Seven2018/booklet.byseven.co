class InterviewQuestion < ApplicationRecord
  belongs_to :interview_form
  acts_as_list scope: :interview_form
  has_many :interview_answers, dependent: :destroy
  serialize :options,Hash

  scope :not_separator, -> { where.not(question_type: 'separator') }
  scope :required, -> { where(required: true) }

  enum visible_for: {
    all: 0,
    manager: 10,
    employee: 20,
  }, _prefix: true

  enum required_for: {
    none: 0,
    all: 10,
    manager: 20,
    employee: 30
  }, _prefix: true

  # TODO refacto question_type => enum
  # for perf + having below getters out of the box

  ####################
  # INSTANCE METHODS #
  ####################

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

  def objective?
    question_type == 'objective'
  end

  def required?
    required_for != 'none'
  end

  def required_for?(option = nil)
    if option == 'employee'
      self.required_for_employee? || self.required_for_all?
    elsif option == 'manager'
      self.required_for_manager? || self.required_for_all?
    end
  end



  #################
  # CLASS METHODS #
  #################

  def self.visible?(option)
    if option == 'employee'
      self.where(visible_for: ['all', 'employee'])
    else
      self.where(visible_for: ['all', 'manager'])
    end
  end

  def self.required_for(option)
    if option == 'employee'
      self.where(required_for: ['all', 'employee'])
    else
      self.where(required_for: ['all', 'manager'])
    end
  end
end
