class CreateFolders < ActiveRecord::Migration[6.0]
  def change
    create_table :folders do |t|
      t.string :title
      t.text :description
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
