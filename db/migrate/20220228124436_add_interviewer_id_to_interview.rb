class AddInterviewerIdToInterview < ActiveRecord::Migration[6.0]
  def change
    unless column_exists?(:interviews, :interviewer_id)
      add_reference :interviews, :interviewer, foreign_key: { to_table: :users }
    end
  end
end
