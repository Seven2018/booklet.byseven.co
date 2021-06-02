class CreateSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :sessions do |t|
      t.date :date
      t.date :available_date
      t.time :starts_at
      t.time :ends_at
      t.references :training, foreign_key: true
      t.references :content, foreign_key: true
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
