class CreateObjectiveElements < ActiveRecord::Migration[6.0]
  def change
    create_table :objective_elements do |t|
      t.string :title, null: false
      t.text :description, default: ""
      t.date :due_date
      t.bigint :objectivable_id
      t.string :objectivable_type
      t.references :company, foreign_key: true
      t.references :creator, foreign_key: { to_table: 'users' }

      t.timestamps
    end

    Company.first.update applications: ['trainings', 'interviews', 'objectives'] if Company.count > 0
  end
end
