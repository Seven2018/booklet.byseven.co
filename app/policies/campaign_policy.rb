class CampaignPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.employee_or_above?
        scope.all
      else
        raise Pundit::NotAuthorizedError, 'not allowed to view this action'
      end
    end
  end

  def index?
    user.employee_or_above?
  end

  def my_campaigns?
    true
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
    user.employee_or_above?
  end

  def send_notification_email?
    user.manager_or_above?
  end

  def campaign_select_owner?
    user.hr_or_above?
  end

  def campaign_add_user?
    user.manager_or_above?
  end

  def campaign_remove_user?
    user.manager_or_above?
  end

  def destroy?
    user.manager_or_above?
  end
end
