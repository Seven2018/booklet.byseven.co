class CreateTeamCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :team_categories do |t|

      t.references :team, foreign_key: true
      t.references :category, foreign_key: true
      t.timestamps
    end
  end
end
