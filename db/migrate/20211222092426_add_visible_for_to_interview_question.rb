class AddVisibleForToInterviewQuestion < ActiveRecord::Migration[6.0]
  def change
    add_column :interview_questions, :visible_for, :integer, default: 0, null: false
  end
end
