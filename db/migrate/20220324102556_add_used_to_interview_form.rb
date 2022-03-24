class AddUsedToInterviewForm < ActiveRecord::Migration[6.0]
  def change
    add_column :interview_forms, :used, :boolean, default: false
  end
end
