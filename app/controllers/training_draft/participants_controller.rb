# frozen_string_literal: true

class TrainingDraft::ParticipantsController < TrainingDraft::BaseController
  def update
    # training_draft.update training_draft_params
    # if all_params_persisted?
      training_draft.participants_set!
      redirect_to edit_training_draft_contents_path
    # else
    #   flash[:alert] = validation_error_flash_message
      # redirect_to edit_training_draft_participants_path
    # end
  end

  private

  def training_draft_params_keys
    %i[participant_ids]
  end

  def previous_steps_params_keys
    %i[]
  end
end
