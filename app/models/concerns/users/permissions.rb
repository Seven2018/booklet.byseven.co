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

  PERMISSIONS_DISPLAY = [
    {interviews: [
        OpenStruct.new(permission: 'can_create_campaigns',
                       title: 'Create and edit campaigns',
                       description: 'Access to campaign index. Allows to create new campaigns using existing templates. Campaigns created can also be edited (deadline, interviewees, interviewers, unlock interviews ...)'),
        OpenStruct.new(permission: 'can_create_templates',
                       title: 'Create and edit templates',
                       description: 'Access to template index. Allows to create and edit existing templates.'),
        OpenStruct.new(permission: 'can_create_interview_reports',
                       title: 'Create interview reports',
                       description: 'Access to report index. Allows to create reports on any campaign.')
    ]},
    {trainings: [
        OpenStruct.new(permission: 'can_read_contents',
                       title: 'View catalog',
                       description: 'Access to the Catalog page. Allows read created contents.'),
        OpenStruct.new(permission: 'can_create_contents',
                       title: 'Create and edit contents',
                       description: 'Allow to create, edit and delete contents in the catalog.'),
        OpenStruct.new(permission: 'can_create_trainings',
                       title: 'Create trainings',
                       description: 'Access to training index. Allows to view, create and delete trainings.'),
        OpenStruct.new(permission: 'can_edit_training_workshops',
                       title: 'Edit trainings',
                       description: 'Allows to edit workshops within existing trainings (update text, videos ...)'),
        OpenStruct.new(permission: 'can_create_training_reports',
                       title: 'Create training reports',
                       description: 'Access to report index. Allows to view and create reports on existing trainings.')
    ]},
    {employees: [
        OpenStruct.new(permission: 'can_read_employees',
                       title: 'View employees',
                       description: 'Access to the Employees page. Allows to view the employees list and their profiles.'),
        OpenStruct.new(permission: 'can_create_employees',
                       title: 'Create employees',
                       description: 'Allows to create, remove and export employees.'),
        OpenStruct.new(permission: 'can_edit_employees',
                       title: 'Edit users profiles',
                       description: 'Allows to edit informations on users profiles (name, birth date, tags ...).'),
        OpenStruct.new(permission: 'can_edit_permissions',
                       title: 'Edit users premission',
                       description: 'Allows to edit users permissions.')
    ]}

  ]

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
