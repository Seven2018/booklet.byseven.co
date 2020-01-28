class AttendeesController < ApplicationController
  before_action :set_attendee, only: [:destroy]

  def create
    @attendee = Attendee.new(training_workshop_id: params[:training_workshop_id], user_id: params[:user_id], status: 'Confirmed')
    authorize @attendee
    if @attendee.save
      redirect_back(fallback_location: root_path)
    else
      raise
    end
  end

  def create_all
    training = Training.find(params[:training_id])
    @attendees = Attendee.where(training_workshop_id: [training.training_workshops.ids], user_id: params[:user_id])
    authorize @attendees
    unless training.training_workshops.nil?
      training.training_workshops.each do |workshop|
        Attendee.create(training_workshop_id: workshop.id, user_id: params[:user_id], status: 'Confirmed')
      end
    end
    redirect_to training_path(training)
  end

  def destroy
    authorize @attendee
    @attendee.destroy
    redirect_back(fallback_location: root_path)
  end

  def destroy_all
    @attendees = Attendee.where(training_id: params[:training_id], user_id: params[:user_id])
    authorize @attendees
    training = Training.find(params[:training_id])
    unless training.training_workshops.nil?
      training.training_workshops.each do |workshop|
        Attendee.find_by(user_id: params[:user_id], training_workshop_id: workshop.id).destroy
      end
    end
    redirect_to training_path(training)
  end

  def invite_user_to_training
    training = Training.find(params[:training_id])
    @attendees = Attendee.where(training_workshop_id: [training.training_workshops.ids])
    authorize @attendees
    params.permit
    user_ids = params[:training][:user_ids].drop(1).map(&:to_i)
    users = User.where(id: [user_ids])
    users.each do |user|
      training.training_workshops.each do |training_workshop|
        Attendee.create(training_workshop_id: training_workshop.id, user_id: user.id, status: 'Invited')
        Notification.create(content: "You have been invited to the following training: #{training.title}", user_id: user.id)
      end
    end
    (User.joins(:attendees).where(attendees: {training_workshop_id: [training.training_workshops.ids]}).uniq - users).each do |user|
      Attendee.where(training_workshop_id: [training.training_workshops.ids], user_id: user.id).destroy_all
      Notification.create(content: "Invitation cancelled: #{training.title}", user_id: user.id)
    end
    redirect_back(fallback_location: root_path)
  end

  def invite_user_to_workshop
    training_workshop = TrainingWorkshop.find(params[:training_workshop_id])
    @attendees = Attendee.where(training_workshop_id: training_workshop.id)
    authorize @attendees
    user_ids = params[:training_workshop][:user_ids].drop(1).map(&:to_i)
    users = User.where(id: [user_ids])
    users.each do |user|
      Attendee.create(training_workshop_id: training_workshop.id, user_id: user.id, status: 'Invited')
      Notification.create(content: "You have been invited to the following workshop: #{training_workshop.title}", user_id: user.id)
    end
    (User.joins(:attendees).where(attendees: {training_workshop_id: training_workshop.id}) - users).each do |user|
      Attendee.find_by(user_id: user.id, training_workshop_id: training_workshop.id).destroy
      Notification.create(content: "Invitation cancelled: #{training_workshop.title}", user_id: user.id)
    end
    redirect_back(fallback_location: root_path)
  end

  def mark_as_completed
    @attendees = Attendee.where(training_workshop_id: params[:training_workshop_id])
    authorize @attendees
    user_ids = params[:training_workshop][:user_ids].drop(1).map(&:to_i)
    @attendees.each do |attendee|
      attendee.mark_as_completed if user_ids.include?(attendee.user_id)
    end
    redirect_back(fallback_location: root_path)
  end

  def confirm_training
    training = Training.find(params[:training_id])
    @attendees = Attendee.where(training_workshop_id: [training.training_workshops.ids], user_id: current_user.id)
    authorize @attendees
    @attendees.update_all(status: 'Confirmed')
    redirect_back(fallback_location: root_path)
  end

  def confirm_training_workshop
    training_workshop = TrainingWorkshop.find(params[:training_workshop_id])
    @attendee = Attendee.where(training_workshop_id: training_workshop.id, user_id: current_user.id).first
    authorize @attendee
    @attendee.update(status: 'Confirmed')
    redirect_back(fallback_location: root_path)
  end

  private

  def set_attendee
    @attendee = Attendee.find(params[:id])
  end
end
