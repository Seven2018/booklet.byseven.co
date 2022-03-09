class CreateCsvImportUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :csv_import_users do |t|
      t.jsonb :data, default: {}, null: false
      t.integer :state, default: 0, null: false
      t.references :creator, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
