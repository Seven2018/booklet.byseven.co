class AddCanEditPermissionsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :can_edit_permissions, :boolean, default: false, null: false
  end
end
