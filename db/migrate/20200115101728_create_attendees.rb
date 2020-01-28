class CreateAttendees < ActiveRecord::Migration[6.0]
  def change
    create_table :attendees do |t|
      t.string :status, null: false, default: "Not completed"
      t.references :user, foreign_key: true
      t.references :training_workshop, foreign_key: true
      t.timestamps
    end
  end
end
