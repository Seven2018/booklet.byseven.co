class CreateTrainings < ActiveRecord::Migration[6.0]
  def change
    create_table :trainings do |t|
      t.string :title
      t.references :folder, foreign_key: true
      t.references :content, foreign_key: true
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
