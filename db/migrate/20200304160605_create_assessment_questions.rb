class CreateAssessmentQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :assessment_questions do |t|
      t.string :question
      t.string :answer
      t.string :question_type
      t.integer :position
      t.boolean :logic_jump, default: false
      t.boolean :active, default: false
      t.references :assessment, foreign_key: true
      t.timestamps
    end
  end
end
