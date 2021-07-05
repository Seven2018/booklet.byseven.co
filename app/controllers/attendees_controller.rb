class AttendeesController < ApplicationController
  before_action :set_attendee, only: []

  private

  def set_attendee
    @attendee = Attendee.find(params[:id])
  end

  def set_current_user
    Current.user = current_user
  end
end
