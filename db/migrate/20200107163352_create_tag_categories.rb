class CreateTagCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_categories do |t|
      t.string :name
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
