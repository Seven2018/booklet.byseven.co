class CreateWorkshopMods < ActiveRecord::Migration[6.0]
  def change
    create_table :workshop_mods do |t|
      t.integer :position, null: false, default: 0
      t.references :mod, foreign_key: true
      t.references :workshop, foreign_key: true
      t.timestamps
    end
  end
end
