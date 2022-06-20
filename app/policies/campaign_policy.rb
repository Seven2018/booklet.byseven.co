class CampaignPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      super
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

  def destroy?
    create? || record.interviews.where(status: :submitted).empty?
  end

  def my_interviews?
    true
  end

  def my_team_interviews?
    user.access_level_int.to_sym != :employee
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
