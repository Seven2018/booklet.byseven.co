# frozen_string_literal: true

class TrainingDraft::Dates::TimeSlotFormsController < TrainingDraft::BaseController
  def create
    render partial: 'training_draft/dates/time_slot', locals: {
      time_slot: TrainingDraft.new_time_slot
    }
  end
end
