# frozen_string_literal: true

class TrainingDraft::DatesController < TrainingDraft::BaseController
  before_action :set_time_slots, only: :edit

  def update
    td_params = {}
    td_params[:cost_per_employee] = training_draft_params[:cost_per_employee]
    time_slots = training_draft_params[:time_slots] || []
    if training_draft.content.asynchronous?
      if time_slots[0]['async_date']
        date = time_slots[0]['async_date'].split('to')[0]
        available_date = time_slots[0]['async_date'].split('to')[1]
        td_params[:time_slots] = [[['date', date], ['available_date', available_date]]]
      end
    else
      td_params[:time_slots] = time_slots.map { |ts| ts.to_h.to_a if ts['date'].present? }.compact
    end
    training_draft.update td_params
    if current_params_persisted?
      training_draft.dates_set!
      redirect_to edit_training_draft_launches_path
    else
      flash[:alert] = validation_error_flash_message
      redirect_to edit_training_draft_dates_path
    end
  end

  private

  def set_time_slots
    @time_slots = training_draft.time_slots.map { |ts| ts.to_h.to_o } + [TrainingDraft.new_time_slot]
  end

  def training_draft_params_keys
    [:cost_per_employee, time_slots: [:date, :starts_at, :ends_at, :async_date]]
  end

  def previous_steps_params_keys
    %i[participant_ids content_id]
  end
end
