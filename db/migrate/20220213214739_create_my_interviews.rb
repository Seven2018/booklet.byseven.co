class CreateMyInterviews < ActiveRecord::Migration[6.0]
  def change
    create_table :my_interviews do |t|

      t.timestamps
    end
  end
end
