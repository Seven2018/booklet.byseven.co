# frozen_string_literal: true

class TrainingDraft::ContentsController < TrainingDraft::BaseController
  def update
    training_draft.update training_draft_params
    if current_params_persisted?
      training_draft.contents_set!
      redirect_to edit_training_draft_dates_path
    else
      flash[:alert] = validation_error_flash_message
      redirect_to edit_training_draft_contents_path
    end
  end

  private

  def training_draft_params_keys
    %i[workshop_id]
  end

  def previous_steps_params_keys
    %i[participant_ids]
  end
end
