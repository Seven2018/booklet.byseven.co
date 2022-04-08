class FixUserApplicationType < ActiveRecord::Migration[6.0]
  def change
    remove_column :companies, :applications
    add_column :companies, :applications, :jsonb, default: {}, null: false
  end
end
