class AddingCategoriesToCampaign < ActiveRecord::Migration[6.0]
  def change
    create_table :campaigns_categories, id: false do |t|
      t.belongs_to :campaign
      t.belongs_to :category
    end
  end
end
