class CreateWorkshopSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :workshop_skills do |t|

      t.timestamps
    end
  end
end
