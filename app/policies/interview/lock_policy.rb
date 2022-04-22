class Interview::LockPolicy < ApplicationPolicy
  def create?
    return false if record.locked?

    return true if
      record.crossed? &&
      record.campaign.completion_for(record.employee) >= 67 &&
      user == record.campaign.owner || user.can_create_campaigns

    super
  end
end
