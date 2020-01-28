class CreateTrainingPrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :training_programs do |t|
      t.string :title, null: false, default: ""
      t.text :description, null: false, default: ""
      t.string :image, null: false, default: ""
      t.integer :participant_number, null: false, default: 0
      t.references :company, foreign_key: true
      t.timestamps
    end
  end
end
