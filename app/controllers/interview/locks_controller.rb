class Interview::LocksController < ApplicationController
  def create
    authorize interview, policy_class: Interview::LockPolicy
    interview.lock!
    redirect_to campaign_path(interview.campaign, employee_id: interview.employee_id)
  end

  private

  def interview
    @interview ||= Interview.find params[:interview_id]
  end
end
