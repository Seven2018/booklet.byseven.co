class AddStatusToObjectiveElements < ActiveRecord::Migration[6.0]
  def change
    add_column :objective_elements, :status, :integer, default: 0
  end
end
