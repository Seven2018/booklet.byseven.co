module Users::Access
  def access_level_int_label
    ACCESS_LEVEL_LABELS[access_level_int.to_sym]
  end

  ACCESS_LEVEL_LABELS = {
    employee: 'Employee',
    manager: 'Manager',
    hr: 'HR',
    account_owner: 'Account Owner',
    admin: 'Admin'
  }

  def hr_or_above?
    hr? || account_owner? || admin?
  end

  def manager_or_above?
    manager? || hr_or_above?
  end

  def employee_or_above?
    employee? || manager_or_above?
  end
end
