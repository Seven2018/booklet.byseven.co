class CreateTrainingDrafts < ActiveRecord::Migration[6.0]
  def change
    create_table :training_drafts do |t|
      t.references :user, foreign_key: true
      t.integer :state, default: 0, null: false
      t.jsonb :data, default: {}

      t.timestamps
    end
  end
end
