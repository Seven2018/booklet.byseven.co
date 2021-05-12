class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :title, null: false, default: ""
      t.references :company, foreign_key: true
      t.timestamps
    end
  end
end
