class CreateUserForms < ActiveRecord::Migration[6.0]
  def change
    create_table :user_forms do |t|
      t.integer :grade
      t.boolean :validated, default: false
      t.references :user, foreign_key: true
      t.references :mod, foreign_key: true
      t.timestamps
    end
  end
end
