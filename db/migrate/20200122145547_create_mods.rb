class CreateMods < ActiveRecord::Migration[6.0]
  def change
    create_table :mods do |t|
      t.string :title, null: false, default: ""
      t.integer :duration, null: false, default: 0
      t.text :content, null: false, default: ""
      t.string :link
      t.string :document
      t.string :video
      t.string :mod_type, default: ""
      t.references :company, foreign_key: true
      t.integer :content_id
      t.timestamps
    end
  end
end
