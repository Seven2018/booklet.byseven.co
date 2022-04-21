module Users::Permissions
  EMPLOYEE_PERMISSIONS = {
    can_create_campaigns:         false,
    can_create_templates:         false,
    can_create_interview_reports: false,
    can_read_contents:            false,
    can_create_contents:          false,
    can_create_trainings:         false,
    can_edit_training_workshops:  false,
    can_create_training_reports:  false,
    can_read_employees:           false,
    can_create_employees:         false,
    can_edit_employees:           false,
    can_edit_permissions:         false
  }

  MANAGER_PERMISSIONS = {
    can_create_campaigns:         false,
    can_create_templates:         false,
    can_create_interview_reports: false,
    can_read_contents:            true,
    can_create_contents:          false,
    can_create_trainings:         false,
    can_edit_training_workshops:  false,
    can_create_training_reports:  false,
    can_read_employees:           false,
    can_create_employees:         false,
    can_edit_employees:           false,
    can_edit_permissions:         false
  }

  ADMIN_PERMISSIONS = {
    can_create_campaigns:         true,
    can_create_templates:         true,
    can_create_interview_reports: true,
    can_read_contents:            true,
    can_create_contents:          true,
    can_create_trainings:         true,
    can_edit_training_workshops:  true,
    can_create_training_reports:  true,
    can_read_employees:           true,
    can_create_employees:         true,
    can_edit_employees:           true,
    can_edit_permissions:         true
  }

  def compare_permissions(preset)
    user_permissions = self.slice(preset.keys).symbolize_keys

    user_permissions != preset
  end
  
    def set_initial_permissions!
    case
    when employee?       then assign_attributes EMPLOYEE_PERMISSIONS
    when manager?        then assign_attributes MANAGER_PERMISSIONS
    when hr?             then assign_attributes ADMIN_PERMISSIONS
    when account_owner?  then assign_attributes ADMIN_PERMISSIONS
    when admin?          then assign_attributes ADMIN_PERMISSIONS
    end
  end

  def preset_permissions_is_dirty?
    case
    when employee?       then return compare_permissions EMPLOYEE_PERMISSIONS
    when manager?        then return compare_permissions MANAGER_PERMISSIONS
    when hr?             then return compare_permissions ADMIN_PERMISSIONS
    when account_owner?  then return compare_permissions ADMIN_PERMISSIONS
    when admin?          then return compare_permissions ADMIN_PERMISSIONS
    end
  end
end
