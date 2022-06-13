class CreateGroupCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :group_categories do |t|
      t.string :name

      t.timestamps
    end
    GroupCategory.create(name: 'others')

    add_reference :categories, :group_category, foreign_key: true, null: true
  end
end
