class CreateTrainingWorkshops < ActiveRecord::Migration[6.0]
  def change
    create_table :training_workshops do |t|
      t.string :title, null: false, default: ""
      t.date :date
      t.time :start_time
      t.time :end_time
      t.references :training, foreign_key: true
      t.references :workshop, foreign_key: true
      t.timestamps
    end
  end
end
