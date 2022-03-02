class TrainingsController < ApplicationController

  def my_trainings
    trainings = Training.joins(sessions: :attendees).where(attendees: {user: current_user}).distinct
    authorize trainings

    @future_trainings = trainings.select{|x| next_date == x.next_date.present?}
    # @past_trainings = trainings.select{|x| next_date == x.next_date.nil?}
  end

  def my_team_trainings
    attendees = Attendee.includes(session: :training).where(user_id: current_user.employees.ids).group_by(&:user_id)
    skip_authorization

    @future_trainings = attendees.each{|x,y| attendees[x] = y.map{|z| z.session.training if z.session.training.next_date.present?}.uniq}
    # @past_trainings = attendees.each{|x,y| attendees[x] = y.map{|z| z.session.training if z.session.training.next_date.nil?}.uniq}
  end

  def show
    @training = Training.find(params[:id])
    authorize @training
  end

  def create
    @training = Training.new(training_params)
    authorize @training
    @training.company_id = current_user.company_id
    if @training.save
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @training = Training.find(params[:id])
    authorize @training
    @training.destroy
    redirect_to dashboard_path
  end

  private

  def training_params
    params.require(:training).permit(:title, :folder_id, :auth_token)
  end
end
