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
                 content_id: :integer,
                 cost_per_employee: :integer,
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

  def self.new_time_slot
   OpenStruct.new(date: nil, available_date: nil, starts_at: nil, ends_at: nil)
  end

  def content
    return unless content_id

    Content.find content_id
  end

  def asynchronous?
    content.content_type == 'Asynchronous'
  end

  def participants
    return User.none if participant_ids.blank?

    User.find participant_ids
  end
end
