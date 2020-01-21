class CreateTrainings < ActiveRecord::Migration[6.0]
  def change
    create_table :trainings do |t|
      t.string :title, null: false, default: ""
      t.text :description
      t.string :image, null: false, default: ""
      t.integer :participant_number, null: false, default: 0
      t.references :training_program, foreign_key: true
      t.references :company, foreign_key: true
      t.timestamps
    end
  end
end
