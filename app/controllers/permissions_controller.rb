class PermissionsController < ApplicationController
  before_action :show_navbar_home, only: :edit
  before_action :authorize_permissions, :user

  def edit; end

  def update
    user.update User::EMPLOYEE_PERMISSIONS.merge(permission_params)
    redirect_to edit_user_permissions_path(user)
  end

  private

  def authorize_permissions
    authorize(nil, :edit?, policy_class: PermissionsPolicy)
  end

  def user
    @user ||= User.find params[:user_id]
  end

  def permission_params
    params.require(:user).permit(
      :can_create_campaigns,
      :can_create_templates,
      :can_create_interview_reports,
      :can_read_contents,
      :can_create_contents,
      :can_create_trainings,
      :can_edit_training_workshops,
      :can_create_training_reports,
      :can_read_employees,
      :can_create_employees,
      :can_edit_employees,
      :can_edit_permissions
    )
  end
end
