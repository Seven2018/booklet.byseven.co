class CreateGroupCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :group_categories do |t|
      t.string :name
      t.integer :kind, default: 0
      t.belongs_to :company

      t.timestamps
    end unless GroupCategory.table_exists?

    Company.all.each do |company|
      company.group_categories.create(name: 'others', kind: :interview)
      company.group_categories.create(name: 'others', kind: :training)
    end

    add_reference :categories, :group_category, foreign_key: true, null: true

    Category.all.each do |category|
      company = category.company
      kind = category.kind

      group_category = GroupCategory.find_by(company: company, kind: kind)
      category.update(group_category: group_category)
    end
  end
end
