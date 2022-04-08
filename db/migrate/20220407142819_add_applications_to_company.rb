class AddApplicationsToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :applications, :text, default: "", null: false
  end
end
