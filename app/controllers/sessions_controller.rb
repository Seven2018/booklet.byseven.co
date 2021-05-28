class SessionsController < ApplicationController

  def book_sessions
    params.permit!
    params_session = params[:session].except(:selected, :booked_sessions)
    @session = Session.new(params_session)
    authorize @session
    @session.company_id = current_user.company_id
    @content = Content.find(params[:session][:content_id])
    if @session.save
      @selected_contents = Content.where(id: params[:session][:selected].split(',') - [@content_id.to_s])
      params[:session][:book_sessions].present? ? @booked_sessions = Sessions.where(id: params[:session][:booked_sessions].split(',') + [@session.id.to_s]) : @booked_sessions = [@session]
      respond_to do |format|
        format.js
      end
    end
  end

  def book_sessions_update
    params.permit!
    params_session = params[:session].except(:selected, :session_id, :booked_sessions)
    @session = Session.find(params[:session][:session_id])
    authorize @session
    @session.update(params_session)
    @selected_contents = Content.where(id: params[:session][:selected].split(','))
    flash[:notice] = 'Date updated'
    respond_to do |format|
      format.js
    end
  end
end
