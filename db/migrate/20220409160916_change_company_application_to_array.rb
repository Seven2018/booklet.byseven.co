class ChangeCompanyApplicationToArray < ActiveRecord::Migration[6.0]
  def change
    remove_column :companies, :applications
    add_column :companies, :applications, :text, array: true, default: []
  end
end
