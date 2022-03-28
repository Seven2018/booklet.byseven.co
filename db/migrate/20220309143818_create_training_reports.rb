class CreateTrainingReports < ActiveRecord::Migration[6.0]
  def change
    create_table :training_reports do |t|
      t.references :company, null: false, foreign_key: true
      t.jsonb :data, default: {}, null: false
      t.integer :state, null: false, default: 0
      t.integer :mode, null: false, default: 0
      t.datetime :start_time
      t.datetime :end_time
      t.string :signature
      t.references :creator, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
