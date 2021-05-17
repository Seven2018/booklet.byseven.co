class CreateContentSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :content_skills do |t|
      t.references :skill, foreign_key: true
      t.references :content, foreign_key: true
      t.timestamps
    end
  end
end
