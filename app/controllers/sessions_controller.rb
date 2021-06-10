class SessionsController < ApplicationController

  def book_sessions
    params.permit!
    params_session = params[:session].except(:selected, :selected_users, :duration)
    @session = Session.new(params_session)
    authorize @session
    @session.company_id = current_user.company_id
    @content = Content.find(params[:session][:content_id])
    if @session.save
      User.where(id: params[:session][:selected_users].split(',')).each do |user|
        Attendee.create(user_id: user.id, session_id: @session.id, creator_id: current_user.id)
      end
      redirect_to dashboard_path
    end
  end

  def update
    @session = Session.find(params[:id])
    authorize @session
    @session.update(session_params)
    redirect_to dashboard_path
  end

  def destroy
    @session = Session.find(params[:id])
    authorize @session
    @session.destroy
    redirect_to dashboard_path
  end

  private

  def session_params
    params.require(:session).permit(:date, :available_date, :starts_at, :ends_at)
  end
end
