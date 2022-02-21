class AddAccessLevelIntToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :access_level_int, :integer, default: 0, null: false
  end
end
