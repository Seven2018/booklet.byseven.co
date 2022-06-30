class Campaigns::BaseController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  private

  def campaign
    @campaign ||= Campaign.find(params[:id].presence || params.dig(:interview_set, :campaign_id))
  end
end
