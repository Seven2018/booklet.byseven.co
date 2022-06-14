class AddDeadlineToCampaign < ActiveRecord::Migration[6.0]
  def change
    add_column :campaigns, :deadline, :date
    add_column :campaigns, :calendar_uuid, :string

    Campaign.all.each do |campaign|
      campaign.update deadline: campaign.interviews.order(date: :desc).map(&:date).first
    end
  end
end
