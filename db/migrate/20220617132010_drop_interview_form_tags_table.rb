class DropInterviewFormTagsTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :interview_form_tags
  end
end
