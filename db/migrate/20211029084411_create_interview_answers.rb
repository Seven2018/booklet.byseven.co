class CreateInterviewAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :interview_answers do |t|
      t.text :answer, null: false, default: ""
      t.text :comments
      t.references :interview, foreign_key: true
      t.references :interview_question, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
