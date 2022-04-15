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
end
