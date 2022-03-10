class Campaigns::BaseController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  include InterviewUsersFilter
  private

  def campaign
    @campaign ||= Campaign.find params[:id]
  end
end
