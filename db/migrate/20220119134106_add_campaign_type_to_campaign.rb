class AddCampaignTypeToCampaign < ActiveRecord::Migration[6.0]
  def change
    add_column :campaigns, :campaign_type, :integer, default: 0, null: false
  end
end
