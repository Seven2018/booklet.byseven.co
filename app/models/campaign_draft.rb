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

  jsonb_accessor :data,
                 title: :string,
                 kind: :string,
                 interviewee_selection_method: :string,
                 interviewer_selection_method: :string,
                 templates_selection_method: :string,
                 date: :datetime,
                 starts_at: [:string, default: '09:00'],
                 ends_at: [:string, default: '10:00'],
                 owner_id: :integer,
                 default_interviewer_id: :integer,
                 default_template_id: :integer,
                 interviewee_ids: [:string, array: true, default: []],
                 interview_sets: [:string, array: true, default: []]

  def default_interviewer
    return unless default_interviewer_id

    User.find  default_interviewer_id
  end
end
