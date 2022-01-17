class Interview::LockPolicy < ApplicationPolicy
  def create?
    return false if record.locked?

    return true if
      record.crossed? &&
      record.campaign.completion_for(record.employee) >= 67 &&
      user == record.campaign.owner || user.hr_or_above?

    super
  end
end
