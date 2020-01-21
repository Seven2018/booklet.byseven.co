class CreateWorkshopSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :workshop_skills do |t|
      t.references :skill, foreign_key: true
      t.references :workshop, foreign_key: true
      t.timestamps
    end
  end
end
