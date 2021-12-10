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
    check_access_manager
  end

  def campaign_select_users?
    check_access_manager
  end

  def campaign_select_dates?
    check_access_manager
  end

  def create?
    check_access_manager
  end

  def show?
    check_access
  end

  def send_notification_email?
    check_access_manager
  end

  def destroy?
    check_access_manager
  end

  private

  def check_access_manager
    ['Super Admin', 'Account Owner', 'HR', 'Manager'].include? user.access_level
  end

  def check_access
    ['Super Admin', 'Account Owner', 'HR', 'Manager', 'HR-light', 'Manager-light', 'Employee'].include? user.access_level
  end
end
