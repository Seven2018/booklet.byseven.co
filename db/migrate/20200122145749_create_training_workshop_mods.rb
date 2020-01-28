class CreateTrainingWorkshopMods < ActiveRecord::Migration[6.0]
  def change
    create_table :training_workshop_mods do |t|
      t.integer :position, null: false, default: 0
      t.references :mod, foreign_key: true
      t.references :training_workshop, foreign_key: true
      t.string :comments, null: false, default: ""
      t.timestamps
    end
  end
end
