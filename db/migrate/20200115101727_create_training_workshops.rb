class CreateTrainingWorkshops < ActiveRecord::Migration[6.0]
  def change
    create_table :training_workshops do |t|
      t.string :title, null: false, default: ""
      t.integer :duration, null: false, default: 0
      t.integer :participant_number, null: false, default: 0
      t.text :description, null: false, default: ""
      t.string :workshop_type, null: false, default: ""
      t.string :image, null: false, default: ""
      t.references :company, foreign_key: true
      t.datetime :available_date
      t.datetime :date
      t.time :starts_at
      t.time :ends_at
      t.references :workshop, foreign_key: true
      t.timestamps
    end
  end
end
