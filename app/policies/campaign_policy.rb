class CampaignPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError, 'not allowed to view this action' unless
        user.can_create_campaigns

      scope.all
    end
  end

  def show?
    record.interviewers.uniq.include?(user) || user.hr_or_above?
  end

  def destroy?
    user.can_create_campaigns
  end

  def my_interviews?
    true
  end

  def my_team_interviews?
    # TODO
    user.manager_or_above?
  end

  def send_notification_email?
    user.can_create_campaigns
  end

  def add_interview_set?
    user.can_create_campaigns
  end

  def remove_interview_set?
    user.can_create_campaigns
  end
end
