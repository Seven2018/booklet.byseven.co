class AddRequiredForToInterviewQuestionAndAnswerableByToInterviewForm < ActiveRecord::Migration[6.0]
  def change
    add_column :interview_questions, :required_for, :integer, default: 0, null: false
    add_column :interview_forms, :answerable_by, :integer, default: 0, null: false
    add_column :interview_forms, :cross, :boolean, default: false
  end
end
