class RemoveInterviewFormIdFromCampaign < ActiveRecord::Migration[6.0]
  def change
    remove_column :campaigns, :interview_form_id
  end
end
