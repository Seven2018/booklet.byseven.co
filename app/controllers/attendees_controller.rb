class AttendeesController < ApplicationController
  before_action :set_attendee, only: [:update, :complete_session]

  def update
    authorize @attendee
    @attendee.status = params[:status]
    @attendee.save!
    redirect_to workshop_path(@attendee.session.workshop.id)
  end

  private

  def set_attendee
    @attendee = Attendee.find(params[:id])
  end

  def set_current_user
    Current.user = current_user
  end
end
