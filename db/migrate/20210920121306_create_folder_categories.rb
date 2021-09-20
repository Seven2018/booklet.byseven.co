class CreateFolderCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :folder_categories do |t|

      t.references :folder, foreign_key: true
      t.references :category, foreign_key: true
      t.timestamps
    end
  end
end
