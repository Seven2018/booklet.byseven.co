class CreateUserInterests < ActiveRecord::Migration[6.0]
  def change
    create_table :user_interests do |t|
      t.references :user, foreign_key: true
      t.references :content, foreign_key: true
      t.string :interest_type
      t.timestamps
    end
  end
end
