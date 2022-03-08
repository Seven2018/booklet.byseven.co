# frozen_string_literal: true

class TrainingDraft < ApplicationRecord
  belongs_to :user

  enum state: {
    pending: 0,
    participants: 10,
    contents: 20,
    dates: 30,
    launches: 40
  }, _suffix: :set

  PROGRESS_STATES = {
    participants: "Participants",
    contents: "Workshop",
    dates: "Dates and Costs",
    launches: "Book trainings !"
  }

  scope :launched, -> { where(state: :launches) }
  scope :processing, -> { where.not(state: :launches) }


  jsonb_accessor :data,
                 participant_ids: [:string, array: true, default: []],
                 workshop_id: :integer,
                 cost_cents_per_employee: :integer,
                 time_slots: [
                  :string,
                  array: true,
                  default: [
                    # ex:
                    # ["date", "2022-03-22"],
                    # ["starts_at", "09:00"],
                    # ["ends_at", "10:00"]
                   ]
                 ]

  def workshop
    return unless workshop_id

    Workshop.find workshop_id
  end
end
