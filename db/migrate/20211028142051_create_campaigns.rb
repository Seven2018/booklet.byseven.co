class CreateCampaigns < ActiveRecord::Migration[6.0]
  def change
    create_table :campaigns do |t|
      t.string :title, null: false
      t.text :description, default: ""
      t.references :owner, foreign_key: { to_table: 'users' }
      t.references :company, foreign_key: true
      t.references :interview_form, foreign_key: true
      t.timestamps
    end
  end
end
