class CreateObjectiveIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :objective_indicators do |t|
      t.integer :indicator_type, null: false
      t.integer :status, default: 0
      t.jsonb "options", default: {}, null: false
      t.references :objective_element, foreign_key: true

      t.timestamps
    end
  end
end
