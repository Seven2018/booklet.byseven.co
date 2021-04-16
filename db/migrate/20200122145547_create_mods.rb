class CreateMods < ActiveRecord::Migration[6.0]
  def change
    create_table :mods do |t|
      t.string :title, null: false, default: ""
      t.integer :duration, null: false, default: 0
      t.text :content, null: false, default: ""
      t.string :document, null: false, default: ""
      t.references :company, foreign_key: true
      t.string :mod_type, default: ""
      t.integer :workshop_id
      t.timestamps
    end
  end
end
