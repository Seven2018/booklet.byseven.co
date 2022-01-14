class AddObjectiveToInterviewAnswer < ActiveRecord::Migration[6.0]
  def change
    add_column :interview_answers, :objective, :text
  end
end
