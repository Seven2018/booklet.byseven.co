class CreateContents < ActiveRecord::Migration[6.0]
  def change
    create_table :contents do |t|
      t.string :title, null: false, default: ""
      t.integer :duration, null: false, default: 0
      t.text :description, null: false, default: ""
      t.string :content_type, null: false, default: "Synchronous"
      t.string :image, null: false, default: ""
      t.decimal :cost, precision: 15, scale: 10, default: 0
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
