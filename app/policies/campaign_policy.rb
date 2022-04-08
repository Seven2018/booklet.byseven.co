class CampaignPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError, 'not allowed to view this action' unless
        user.can_create_campaigns && user.company_id.present?

      scope.where(company: user.company)
    end
  end

  def show?
    record.interviewers.uniq.include?(user) || user.hr_or_above?
  end

  def create?
    user.can_create_campaigns
  end

  def destroy?
    create?
  end

  def my_interviews?
    true
  end

  def my_team_interviews?
    # TODO
    user.manager_or_above?
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
