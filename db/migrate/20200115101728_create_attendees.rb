class CreateAttendees < ActiveRecord::Migration[6.0]
  def change
    create_table :attendees do |t|
      t.string :status, null: false, default: "Not completed"
      t.string :calendar_uuid
      t.references :user, foreign_key: true
      t.references :training_workshop, foreign_key: true
      t.belongs_to :creator
      t.timestamps
    end
  end
end
