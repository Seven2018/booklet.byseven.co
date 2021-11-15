class CreateInterviewFormTags < ActiveRecord::Migration[6.0]
  def change
    create_table :interview_form_tags do |t|
      t.string :tag_name, null: false, default: ""
      t.references :interview_form, foreign_key: true
      t.references :tag, foreign_key: true
      t.timestamps
    end
  end
end
