# frozen_string_literal: true

class CampaignDraft < ApplicationRecord
  belongs_to :user

  enum state: {
    pending: 0,
    settings: 10,
    participants: 20,
    templates: 30,
    dates: 40,
    launches: 50
  }, _suffix: :set

  PROGRESS_STATES = {
    settings: "Settings",
    participants: "Participants",
    templates: "Templates",
    dates: "Dates",
    launches: "Review & Launch"
  }

  scope :launched, -> { where(state: :launches) }
  scope :processing, -> { where.not(state: :launches) }
  scope :campaign, -> (owner_id, campaign_id) { where(user_id: owner_id).select{|draft| draft.data['campaign_id'].to_i == campaign_id} }

  jsonb_accessor :data,
                 title: :string,
                 kind: :string,
                 interviewee_selection_method: :string,
                 interviewer_selection_method: :string,
                 templates_selection_method: :string,
                 date: :datetime,
                 starts_at: [:string, default: '09:00'],
                 ends_at: [:string, default: '10:00'],
                 default_interviewer_id: :integer,
                 default_template_id: :integer,
                 multi_templates_category: :integer,
                 multi_templates_ids: [:string, array: true, default: []],
                 interviewee_ids: [:string, array: true, default: []],
                 interview_sets: [:string, array: true, default: []],
                 send_invitation: :boolean

  def direct_manager?
    interviewer_selection_method == 'manager'
  end

  def specific_manager?
    interviewer_selection_method == 'specific_manager'
  end

  def default_interviewer
    return unless default_interviewer_id

    User.find  default_interviewer_id
  end

  def default_template
    return unless default_template_id

    InterviewForm.find  default_template_id
  end

  def interview_form
    return unless default_template_id

    InterviewForm.find default_template_id
  end
end
