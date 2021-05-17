class CreateContents < ActiveRecord::Migration[6.0]
  def change
    create_table :contents do |t|
      t.string :title, null: false, default: ""
      t.integer :duration, null: false, default: 0
      t.text :description, null: false, default: ""
      t.string :image, null: false, default: ""
      t.references :company, foreign_key: true
      t.references :folder, foreign_key: true
      t.belongs_to :author

      t.timestamps
    end
  end
end
