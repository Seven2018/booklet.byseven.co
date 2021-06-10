class CreateMods < ActiveRecord::Migration[6.0]
  def change
    create_table :mods do |t|
      t.string :title
      t.text :text, default: ""
      t.string :link
      t.string :document
      t.string :video
      t.string :image
      t.string :mod_type, default: ""
      t.integer :position
      t.integer :duration, null: false, default: 0
      t.references :company, foreign_key: true
      t.integer :content_id
      t.timestamps
    end
  end
end
