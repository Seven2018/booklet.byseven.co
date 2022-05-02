class CreateObjectiveLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :objective_logs do |t|
      t.string :title, null: false
      t.text :comments
      t.integer :log_type, null: false, default: 0
      t.string :initial_value
      t.string :updated_value
      t.references :owner, foreign_key: { to_table: 'users' }
      t.references :objective_element, foreign_key: true
      t.references :objective_indicator, foreign_key: true

      t.timestamps
    end
  end
end
