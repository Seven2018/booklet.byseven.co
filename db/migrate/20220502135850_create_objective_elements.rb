class CreateObjectiveElements < ActiveRecord::Migration[6.0]
  def change
    create_table :objective_elements do |t|
      t.string :title, null: false
      t.text :description, default: ""
      t.date :due_date
      t.references :objectivable, polymorphic: true
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
