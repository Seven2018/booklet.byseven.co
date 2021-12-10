class CampaignPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if ['Super Admin', 'Account Owner', 'HR', 'Manager', 'HR-light', 'Manager-light', 'Employee'].include? user.access_level
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def index?
    check_access
  end

  def campaigns_report?
    user.hr_or_above?
  end

  def campaigns_report_filter_campaigns?
    user.hr_or_above?
  end

  def campaign_report_info?
    user.hr_or_above?
  end

  def campaign_select_template?
    user.manager_or_above?
  end

  def campaign_select_users?
    user.manager_or_above?
  end

  def campaign_select_dates?
    user.manager_or_above?
  end

  def create?
    user.manager_or_above?
  end

  def show?
    check_access
  end

  def send_notification_email?
    user.manager_or_above?
  end

  def destroy?
    user.manager_or_above?
  end

  private

  def check_access
    ['Super Admin', 'Account Owner', 'HR', 'Manager', 'HR-light', 'Manager-light', 'Employee'].include? user.access_level
  end
end
