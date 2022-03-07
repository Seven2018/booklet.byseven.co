class AddCreatorToCsvExports < ActiveRecord::Migration[6.0]
  def change
    unless column_exists?(:csv_exports, :creator_id)
      add_reference :csv_exports, :creator, foreign_key: { to_table: :users }
    end
  end
end
