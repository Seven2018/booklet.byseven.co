class RemoveRequiredForFromInterviewQuestion < ActiveRecord::Migration[6.0]
  def change
    remove_column :interview_questions, :required_for
  end
end
