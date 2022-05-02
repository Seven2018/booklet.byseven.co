class CreateObjectiveIndicators < ActiveRecord::Migration[6.0]
  def change
    create_table :objective_indicators do |t|

      t.timestamps
    end
  end
end
