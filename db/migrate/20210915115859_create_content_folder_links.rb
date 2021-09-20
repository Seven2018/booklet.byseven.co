class CreateContentFolderLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :content_folder_links do |t|
      t.references :folder, foreign_key: true
      t.references :content, foreign_key: true

      t.timestamps
    end
  end
end
