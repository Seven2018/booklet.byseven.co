class CreateTrainingProgramSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :training_program_skills do |t|

      t.timestamps
    end
  end
end
