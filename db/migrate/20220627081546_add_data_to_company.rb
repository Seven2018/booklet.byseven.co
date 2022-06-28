class AddDataToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :data, :jsonb, default: {}
  end
end
