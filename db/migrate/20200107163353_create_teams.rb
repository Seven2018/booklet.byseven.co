class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :team_name, null: false, default: ""
      t.string :image, null: false, default: ""
      t.references :company, foreign_key: true
      t.timestamps
    end
  end
end
