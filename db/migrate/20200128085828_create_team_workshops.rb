class CreateTeamWorkshops < ActiveRecord::Migration[6.0]
  def change
    create_table :team_workshops do |t|
      t.references :team, foreign_key: true
      t.references :training_workshop, foreign_key: true
      t.timestamps
    end
  end
end
