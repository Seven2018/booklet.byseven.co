class Interview::LockPolicy < ApplicationPolicy
  def create?
    return false if record.locked?

    return true if
      record.crossed? &&
      record.campaign.completion_for(:all) == 100 &&
      user == record.campaign.owner || user.hr_or_above?

    super
  end
end
