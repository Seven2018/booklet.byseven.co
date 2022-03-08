class TrainingsController < ApplicationController

  def my_trainings
    trainings = Training.joins(sessions: :attendees).where(attendees: {user: current_user}).distinct
    authorize trainings

    @future_trainings = trainings.select{|x| next_date == x.next_date.present?}
    # @past_trainings = trainings.select{|x| next_date == x.next_date.nil?}
  end

  def my_team_trainings
    trainings = Training.joins(sessions: :attendees).where(attendees: {user_id: current_user.employees.ids}).distinct
    authorize trainings

    attendees = Attendee.includes(session: :training).where(user_id: current_user.employees.ids).group_by(&:user_id)

    @future_trainings = attendees.each{|x,y| attendees[x] = y.map{|z| z.session.training if z.session.training.next_date.present?}.uniq.sort{|x| x.next_date}}
    # @past_trainings = attendees.each{|x,y| attendees[x] = y.map{|z| z.session.training if z.session.training.next_date.nil?}.uniq.sort{|x| x.next_date}}
  end

  def my_team_trainings_user_details
    @user = User.find(params[:id])
    @user = current_user unless @user.manager != current_user || current_user.hr_or_above?
    @trainings = Training.joins(sessions: :attendees)
                 .where(attendees: {user: @user}).distinct
                 .select{|x| x.next_date.present?}
                 .sort{|y| y.next_date}
    authorize @trainings
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
