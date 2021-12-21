class AddLockedAtToInterview < ActiveRecord::Migration[6.0]
  def change
    add_column :interviews, :locked_at, :datetime
  end
end
