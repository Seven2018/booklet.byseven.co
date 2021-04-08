class CreateTagWorkshops < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_workshops do |t|
      t.references :tag, foreign_key: true
      t.references :training_workshop, foreign_key: true
      t.timestamps
    end
  end
end
