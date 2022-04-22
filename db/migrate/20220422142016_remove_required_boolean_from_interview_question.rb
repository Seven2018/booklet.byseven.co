class RemoveRequiredBooleanFromInterviewQuestion < ActiveRecord::Migration[6.0]
  def change
    remove_column :interview_questions, :required
  end
end
