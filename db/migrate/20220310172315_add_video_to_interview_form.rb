class AddVideoToInterviewForm < ActiveRecord::Migration[6.0]
  def change
    add_column :interview_forms, :video, :string
  end
end
