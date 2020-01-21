class AttendeesController < ApplicationController
  def create
    @attendee = Attendee.new(training_id: params[:training_id], user_id: params[:user_id])
    authorize @attendee
    if @attendee.save
      redirect_back(fallback_location: root_path)
    else
      raise
    end
  end

  def destroy
    @attendee = Attendee.find(params[:id])
    authorize @attendee
    @attendee.destroy
    redirect_back(fallback_location: root_path)
  end
end
