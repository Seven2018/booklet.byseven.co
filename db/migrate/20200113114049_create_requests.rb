class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.string :status, null: false, default: ""
      t.references :user, foreign_key: true
      t.references :training_program, foreign_key: true
      t.timestamps
    end
  end
end
