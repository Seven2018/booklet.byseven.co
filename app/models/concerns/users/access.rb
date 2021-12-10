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
    ACCESS_LEVELS.include? access_level
  end

  def admin
    access_level == 'Super Admin'
  end
  alias admin? admin
  alias super_admin admin
  alias super_admin? admin

  def account_owner?
    access_level == 'Account Owner'
  end

  def hr?
    access_level == 'HR'
  end

  def manager?
    access_level == 'Manager'
  end

  def hr_light?
    access_level == 'HR-light'
  end

  def manager_light?
    access_level == 'Manager-light'
  end

  def employee?
    access_level == 'Employee'
  end

  def employee_to_hr_light?
    [
      'HR-light',
      'Manager-light',
      'Employee'
    ].include? access_level
  end
end
