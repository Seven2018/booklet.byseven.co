class AddingCategoriesToInterviewForm < ActiveRecord::Migration[6.0]
  def change
    create_table :categories_interview_forms, id: false do |t|
      t.belongs_to :category
      t.belongs_to :interview_form
    end
  end
end
