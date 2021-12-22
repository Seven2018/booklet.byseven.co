class Interview::LocksController < ApplicationController
  def create
    authorize interview, policy_class: Interview::LockPolicy
    interview.lock!
    redirect_back fallback_location: root_path
  end

  private

  def interview
    @interview ||= Interview.find params[:interview_id]
  end
end
