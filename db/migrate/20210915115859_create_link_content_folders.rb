class CreateLinkContentFolders < ActiveRecord::Migration[6.0]
  def change
    create_table :link_content_folders do |t|
      t.references :folder, foreign_key: true
      t.references :content, foreign_key: true

      t.timestamps
    end
  end
end
