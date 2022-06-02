class AddArchivedForToInterview < ActiveRecord::Migration[6.0]
  def change
    add_column :interviews, :archived_for, :text
  end
end
