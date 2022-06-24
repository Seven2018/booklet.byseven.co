class AddInterviewFormsListToCampaign < ActiveRecord::Migration[6.0]
  def change
    add_column :campaigns, :interview_forms_list, :text
  end
end
