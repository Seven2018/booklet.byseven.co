class SessionsController < ApplicationController

  # Book the selected contents with selected users as attendees (pages/book)
  def book_sessions
    params.permit!
    params_session = params[:session].except(:selected, :selected_users, :duration)
    @session = Session.new(params_session)
    if params[:session][:date].split(' to ').count > 1
      dates = params[:session][:date].split(' to ')
      @session.date = Date.strptime(dates.first, '%d/%m/%Y')
      @session.available_date = Date.strptime(dates.last, '%d/%m/%Y')
    end
    authorize @session
    @session.company_id = current_user.company_id
    @content = Content.find(params[:session][:content_id])
    if @session.save
      User.where(id: params[:session][:selected_users].split(',')).each do |user|
        Attendee.create(user_id: user.id, session_id: @session.id, creator_id: current_user.id)
      end
      return
    end
  end

  # Update date and time for the selected session (pages/dashboard)
  def update
    @session = Session.find(params[:id])
    authorize @session
    @session.update(session_params)
    redirect_to dashboard_path
  end

  # Delete the selected session (pages/dashboard)
  def destroy
    @session = Session.find(params[:id])
    authorize @session
    @session.destroy
    redirect_to dashboard_path
  end

  private

  def session_params
    params.require(:session).permit(:date, :available_date, :starts_at, :ends_at, :cost)
  end
end
