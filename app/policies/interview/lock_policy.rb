class Interview::LockPolicy < ApplicationPolicy
  def create?
    return false if record.locked?

    return true if
      record.crossed? &&
      record.campaign.completion_for(:all) == 100 &&
      user == record.employee

    super
  end
end
