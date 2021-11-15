class CreateInterviewQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :interview_questions do |t|
      t.string :question
      t.text :description
      t.text :options
      t.string :question_type
      t.integer :position
      t.boolean :logic_jump, default: false
      t.boolean :active, default: true
      t.references :interview_form, foreign_key: true
      t.timestamps
    end
  end
end
