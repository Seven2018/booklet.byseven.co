class SessionsController < ApplicationController

  def book_sessions
    params.permit!
    params_session = params[:session].except(:selected, :selected_users)
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
end
