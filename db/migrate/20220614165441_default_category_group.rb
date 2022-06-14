class DefaultCategoryGroup < ActiveRecord::Migration[6.0]
  def change
    group = GroupCategory.find_by(name: 'others')
    Category.all.each do |category|
      category.update(group_category: group)
    end
  end
end
