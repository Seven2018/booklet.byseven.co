class CreateObjectiveLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :objective_logs do |t|

      t.timestamps
    end
  end
end
