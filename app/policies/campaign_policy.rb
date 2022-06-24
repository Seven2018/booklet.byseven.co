class CampaignPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError, 'not allowed to perform this action' unless
        user.hr_or_above?

      scope.where(company: user.company)
    end
  end

  def list?
    true
  end

  def show?
    record.interviewers.uniq.include?(user) || create?
  end

  def overview?
    create?
  end

  def create?
    user.can_create_campaigns
  end

  def update?
    create?
  end

  def destroy?
    create? || record.interviews.where(status: :submitted).empty?
  end

  def my_interviews?
    true
  end

  def my_interviews_list?
    my_interviews?
  end

  def my_team_interviews?
    user.access_level_int.to_sym != :employee
  end

  def my_team_interviews_list?
    my_team_interviews?
  end

  def send_notification_email?
    create?
  end

  def add_interview_set?
    create?
  end

  def update_interview_set?
    create? || record.interviewers.include?(user)
  end

  def remove_interview_set?
    create?
  end

  def can_unlock?
    user.hr_or_above?
  end

  def campaign_edit_date?
    # TODO devise a better policy
    true
  end


  ###########################
  ## CATEGORIES MANAGEMENT ##
  ###########################

  def toggle_tag?
    create?
  end

  def remove_company_tag?
    create?
  end

  def search_tags?
    create?
  end


  ##############
  ## CALENDAR ##
  ##############

  def redirect_calendar?
    show?
  end

  ##############
end
