class CreateCsvExports < ActiveRecord::Migration[6.0]
  def change
    create_table :csv_exports do |t|
      t.references :company, null: false, foreign_key: true
      t.jsonb :data
      t.integer :state, null: false, default: 0
      t.integer :mode, null: false, default: 0
      t.integer :category
      t.datetime :start_time
      t.datetime :end_time
      t.string :signature

      t.timestamps
    end
  end
end
