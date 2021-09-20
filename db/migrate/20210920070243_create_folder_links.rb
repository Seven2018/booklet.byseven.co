class CreateFolderLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :folder_links do |t|

      t.references :parent, foreign_key: { to_table: 'folders' }
      t.references :child, foreign_key: { to_table: 'folders' }
      t.timestamps
    end
  end
end
