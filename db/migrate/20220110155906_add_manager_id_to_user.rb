class AddManagerIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :manager, foreign_key: { to_table: :users }
  end
end
