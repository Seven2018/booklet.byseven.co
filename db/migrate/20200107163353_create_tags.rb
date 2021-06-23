class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :tag_name, null: false, default: ""
      t.string :image, null: false, default: ""
      t.references :company, foreign_key: true
      t.references :tag_category, foreign_key: true
      t.integer :tag_category_position
      t.timestamps
    end
  end
end
