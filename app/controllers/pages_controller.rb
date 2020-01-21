class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def dashboard
    @my_trainings = Training.joins(:attendees).where(attendees: {user_id: current_user.id})
    @my_workshops = TrainingWorkshop.joins(training: :attendees).where(attendees: {user_id: current_user.id})
  end
end
