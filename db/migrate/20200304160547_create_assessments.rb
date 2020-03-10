class CreateAssessments < ActiveRecord::Migration[6.0]
  def change
    create_table :assessments do |t|
      t.string :title, null: false, default: ""
      t.references :mod, foreign_key: true
      t.timestamps
    end
  end
end
