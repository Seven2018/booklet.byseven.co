# frozen_string_literal: true

class TrainingDraft::Participants::IdsController < TrainingDraft::BaseController
  def update
    @training.update participant_ids: participant_ids
    render json: {
      participant_ids_str: participant_ids.join(','),
      participant_ids_count: participant_ids.count
    }
  end
end
