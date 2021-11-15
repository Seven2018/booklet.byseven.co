class CreateInterviewForms < ActiveRecord::Migration[6.0]
  def change
    create_table :interview_forms do |t|
      t.string :title, null: false
      t.text :description, default: ""
      t.references :company, foreign_key: true
      t.timestamps
    end
  end
end
