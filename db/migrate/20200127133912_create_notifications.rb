class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.string :content, null: false, default: ""
      t.string :status, null: false, default: "Unread"
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
