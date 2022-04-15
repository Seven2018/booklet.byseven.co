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
    can_create_campaigns:         true,
    can_create_templates:         true,
    can_create_interview_reports: false,
    can_read_contents:            true,
    can_create_contents:          true,
    can_create_trainings:         true,
    can_edit_training_workshops:  true,
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
end
