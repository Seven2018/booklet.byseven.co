class CampaignsController < ApplicationController

  def index
    @campaigns = policy_scope(Campaign)
    @campaigns = @campaigns.where(company_id: current_user.company_id)
    authorize @campaigns
    if ['Manager'].include?(current_user.access_level)
      @campaigns = @campaigns.where(owner_id: current_user.id)
    end
  end
end
