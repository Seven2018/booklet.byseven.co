class SessionsController < ApplicationController

  def book_sessions
    skip_authorization
    raise
    @session = Session.new(session_params)
    @session.company_id = current_user.company_id
    @content_id = params[:session][:content_id].to_i
    @selected = Content.where(id: params[:sessions][:selected].split(',') - [@content_id])
    if @session.save
      respond_to do |format|
        format.js
    end
  end

  def book_sessions_update
    skip_authorization
    @session = Session.find(params[:id])
    @session.update(session_params)
    @selected = Content.where(id: params[:sessions][:selected].split(',')
    respond_to do |format|
      format.js
    end
  end

  private

  def session_params
    params.require(:session).permit(:title, :date, :start_time, :end_time, :training_id, :content_id, :company_id)
  end
end
