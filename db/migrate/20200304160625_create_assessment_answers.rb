class CreateAssessmentAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :assessment_answers do |t|
      t.string :answer, null: false, default: ""
      t.boolean :correct
      t.references :assessment_question, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
