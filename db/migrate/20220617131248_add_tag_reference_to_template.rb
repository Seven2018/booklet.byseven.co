class AddTagReferenceToTemplate < ActiveRecord::Migration[6.0]
  def change
    unless column_exists?(:interview_forms, :tag_id)
      add_reference :interview_forms, :tag, foreign_key: { to_table: :tags }
    end
  end
end
