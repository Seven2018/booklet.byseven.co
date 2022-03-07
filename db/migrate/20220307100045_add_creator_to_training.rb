class AddCreatorToTraining < ActiveRecord::Migration[6.0]
  def change
    unless column_exists?(:trainings, :creator_id)
      add_reference :trainings, :creator, foreign_key: { to_table: :users }
    end
  end
end
