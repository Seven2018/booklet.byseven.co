# frozen_string_literal: true

class TrainingDraft::ParticipantsController < TrainingDraft::BaseController
  def update
    training_draft.participants_set!
    redirect_to edit_training_draft_contents_path
  end

  private

  def training_draft_params_keys
    %i[participant_ids]
  end

  def previous_steps_params_keys
    %i[]
  end
end
