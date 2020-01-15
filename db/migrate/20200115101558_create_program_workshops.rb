class CreateProgramWorkshops < ActiveRecord::Migration[6.0]
  def change
    create_table :program_workshops do |t|
      t.references :training_program, foreign_key: true
      t.references :workshop, foreign_key: true
      t.integer :position
      t.timestamps
    end
  end
end
