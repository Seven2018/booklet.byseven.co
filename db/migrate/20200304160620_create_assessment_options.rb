class CreateAssessmentOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :assessment_options do |t|
      t.string :answer
      t.references :assessment_question, foreign_key: true
      t.timestamps
    end
  end
end
