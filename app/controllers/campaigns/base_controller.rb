class Campaigns::BaseController < ApplicationController
  include InterviewUsersFilter
  private

  def campaign
    @campaign ||= Campaign.find params[:id]
  end
end
