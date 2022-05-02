class CreateObjectiveElements < ActiveRecord::Migration[6.0]
  def change
    create_table :objective_elements do |t|

      t.timestamps
    end
  end
end
