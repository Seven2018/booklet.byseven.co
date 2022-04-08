class CampaignDraftPolicy < ApplicationPolicy
  def initialize(user)
    @user = user
  end

  def update?
    user.can_create_campaigns
  end
end
