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
    [
      'Super Admin',
      'Account Owner',
      'HR'
    ].include? access_level
  end

  def manager_or_above?
    [
      'Super Admin',
      'Account Owner',
      'HR',
      'Manager'
    ].include? access_level
  end

  def employee_or_above?
    true
  end
end
