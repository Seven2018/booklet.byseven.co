module Users::Access
  ACCESS_LEVELS = [
    'Super Admin',
    'Account Owner',
    'HR',
    'Manager',
    'HR-light',
    'Manager-light',
    'Employee'
  ]

  def hr_or_above?
    hr? || account_owner? || admin?
  end

  def manager_or_above?
    manager? || hr_or_above?
  end

  def employee_or_above?
    employee? || manager_or_above?
  end

  def employee_to_hr_light?
    [
      'HR-light',
      'Manager-light',
      'Employee'
    ].include? access_level
  end
end
