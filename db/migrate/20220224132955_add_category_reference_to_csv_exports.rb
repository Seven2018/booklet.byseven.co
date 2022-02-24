class AddCategoryReferenceToCsvExports < ActiveRecord::Migration[6.0]
  def change
    remove_column :csv_exports, :category
    add_reference :csv_exports, :tag_category, null: false, foreign_key: true
  end
end
