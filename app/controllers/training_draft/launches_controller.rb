# frozen_string_literal: true

class TrainingDraft::LaunchesController < TrainingDraft::BaseController
  def update
    new_training = TrainingDrafts::Trainings::Launch.call(training_draft: training_draft)
    if new_training.present?
      @training.launches_set!
      if params[:send_email] == 'true'
        attendees = new_training.employees

        attendees.each do |attendee|
          TrainingMailer.with(user: attendee)
            .invite_attendee(attendee, new_training)
            .deliver_later
        end
      end
      redirect_to training_path(new_training)
    else
      flash[:alert] = validation_error_flash_message
      redirect_to edit_campaign_draft_launches_path
    end
  end

  private

  def training_draft_params_keys
    previous_steps_params_keys
  end

  def previous_steps_params_keys
    %i[participant_ids content_id cost_per_employee time_slots]
  end
end
