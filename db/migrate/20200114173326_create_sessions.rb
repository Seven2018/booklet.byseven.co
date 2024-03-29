class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions do |t|
      t.date :date
      t.date :available_date
      t.time :starts_at
      t.time :ends_at
      t.decimal :cost, precision: 15, scale: 10
      t.references :training, foreign_key: true
      t.references :workshop, foreign_key: true

      t.timestamps
    end
  end
end
