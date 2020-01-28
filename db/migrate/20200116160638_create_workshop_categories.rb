class CreateWorkshopCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :workshop_categories do |t|
      t.references :workshop, foreign_key: true
      t.references :category, foreign_key: true
      t.timestamps
    end
  end
end
