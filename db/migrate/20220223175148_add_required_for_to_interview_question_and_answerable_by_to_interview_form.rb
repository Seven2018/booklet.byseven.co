class AddRequiredForToInterviewQuestionAndAnswerableByToInterviewForm < ActiveRecord::Migration[6.0]
  def change
    unless column_exists?(:interview_questions, :required_for)
      add_column :interview_questions, :required_for, :integer, default: 0, null: false
    end
    unless column_exists?(:interview_forms, :answerable_by)
      add_column :interview_forms, :answerable_by, :integer, default: 0, null: false
    end
    unless column_exists?(:interview_forms, :cross)
      add_column :interview_forms, :cross, :boolean, default: false
    end
  end
end
