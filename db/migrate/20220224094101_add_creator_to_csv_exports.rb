class AddCreatorToCsvExports < ActiveRecord::Migration[6.0]
  def change
    add_reference :csv_exports, :creator, foreign_key: { to_table: :users }
  end
end
