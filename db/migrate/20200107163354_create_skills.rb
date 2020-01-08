class CreateSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :skills do |t|
      t.string :title, null: false, default: ""
      t.string :description, null: false, default: ""
      t.timestamps
    end
  end
end
