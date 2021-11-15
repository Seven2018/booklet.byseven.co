class CreateInterviews < ActiveRecord::Migration[6.0]
  def change
    create_table :interviews do |t|
      t.string :title, null: false
      t.text :description, default: ""
      t.boolean :completed, default: false
      t.string :label, null: false
      t.date :date
      t.time :starts_at
      t.time :ends_at
      t.references :interview_form, foreign_key: true
      t.references :employee, foreign_key: { to_table: 'users' }
      t.references :creator, foreign_key: { to_table: 'users' }
      t.references :campaign, foreign_key: true
      t.timestamps
    end
  end
end
