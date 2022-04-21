module Users::Access
  def access_level_int_preset
    ACCESS_LEVEL_LABELS[access_level_int.to_sym]
  end

  ACCESS_LEVEL_LABELS = {
    employee: 'Employee',
    manager: 'Manager',
    hr: 'Admin',
    account_owner: 'Admin',
    admin: 'Admin'
  }
end
