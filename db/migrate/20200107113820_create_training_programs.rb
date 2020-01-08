class CreateTrainingPrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :training_programs do |t|
      t.string :title, null: false, default: ""
      t.date :start_date
      t.date :end_date
      t.integer :participant_number, null: false, default: 0
      t.timestamps
    end
  end
end
