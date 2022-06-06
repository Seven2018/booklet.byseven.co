require 'csv'

class Campaign < ApplicationRecord
  include Campaigns::Stats
  class AmbiguousInterviewQuery < StandardError; end

  belongs_to :company
  belongs_to :owner, class_name: "User"
  belongs_to :interview_form, optional: true
  has_many :interviews, dependent: :destroy
  has_many :employees, through: :interviews
  has_many :interviewers, through: :interviews
  has_and_belongs_to_many :categories

  validates :title, presence: true

  paginates_per 10

  enum campaign_type: {
    simple: 0,
    crossed: 10,
    one_to_one: 20,
    feedback_360: 30
  }

  include PgSearch::Model
  pg_search_scope :search_campaigns,
    against: [ :title ],
    associated_against: {
      owner: [:lastname, :firstname, :email],
      employees: [:lastname, :firstname, :email]
    },
    using: {
      tsearch: { prefix: true }
    },
    ignoring: :accents

  alias :manager :owner

  def self.start_at(date)
    joins(:interviews)
      .where('date >= ?', date)
      .distinct
  end

  def self.end_at(date)
    joins(:interviews)
      .where('date <= ?', date)
      .distinct
  end

  def deadline
    interviews.order(date: :asc).first&.date
  end

  def interview_sets(employee_id = nil)
    @interview_sets ||=
      if employee_id.nil?
        employees.distinct.ids.map { |employee_id| interviews.find_by(employee_id: employee_id).set }
      else
        interviews.find_by(employee_id: employee_id).set
      end
  end

  def interview_forms
    interviews.map{|x| x.interview_form}.uniq
  end

  def completion_for(employee)
    return 0 if interviews.count.zero?

    return (interviews.submitted.count.fdiv(interviews.count) * 100).round if employee == :all

    return 0 if interviews.where(employee: employee).count.zero?

    (
      interviews.submitted.where(employee: employee).count
      .fdiv(interviews.where(employee: employee).count) * 100
    ).round
  end

  def completion_for_interviewer(interviewer)
    return 0 if interviews.count.zero?
    return 0 if interviews.where(interviewer: interviewer).count.zero?

    (interviews.locked.where(interviewer: interviewer).count
      .fdiv(interviews.where(interviewer: interviewer).count) * 100).round
  end

  def manager_interview(employee_id = nil)
    if interviews.select(&:manager?).count == 1
      return interviews.find(&:manager?)
    end

    raise AmbiguousInterviewQuery unless employee_id

    interviews.where(employee_id: employee_id).find(&:manager?)
  end

  def employee_interview(employee_id = nil)
    if interviews.select(&:employee?).count == 1
      return interviews.find(&:employee?)
    end

    raise AmbiguousInterviewQuery unless employee_id

    interviews.where(employee_id: employee_id).find(&:employee?)
  end

  def crossed_interview(employee_id = nil)
    if interviews.select(&:crossed?).count == 1
      return interviews.find(&:crossed?)
    end

    raise AmbiguousInterviewQuery unless employee_id

    interviews.where(employee_id: employee_id).find(&:crossed?)
  end

  # CATEGORIES ADDED DIRECTLY TO CAMPAIGN (obsolete?)
  # def tags
  #   return [] unless interviews.present? && interviews.first.interview_form.present?

  #   interviews.first.interview_form.categories.pluck(:title)
  # end


end
