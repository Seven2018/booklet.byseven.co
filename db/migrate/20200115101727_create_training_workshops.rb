class CreateTrainingWorkshops < ActiveRecord::Migration[6.0]
  def change
    create_table :training_workshops do |t|
      t.references :training, foreign_key: true
      t.references :workshop, foreign_key: true
      t.integer :position
      t.timestamps
    end
  end
end
