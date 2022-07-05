class AddPotionToGroupCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :group_categories, :position, :integer, default: 0

    GroupCategory.where.not(name: 'others').update_all(position: 1)
  end
end
