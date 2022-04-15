class CampaignPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      super
      raise Pundit::NotAuthorizedError, 'not allowed to perform this action' unless
        user.can_create_campaigns

      scope.where(company: user.company)
    end
  end

  def show?
    record.interviewers.uniq.include?(user) || create?
  end

  def create?
    user.can_create_campaigns
  end

  def destroy?
    create? || record.interviews.where(completed: true).empty?
  end

  def my_interviews?
    true
  end

  def my_team_interviews?
    # TODO UpdatePermission
    true
  end

  def send_notification_email?
    create?
  end

  def add_interview_set?
    create?
  end

  def remove_interview_set?
    create?
  end
end
