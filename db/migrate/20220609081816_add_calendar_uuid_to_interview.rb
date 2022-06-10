class AddCalendarUuidToInterview < ActiveRecord::Migration[6.0]
  def change
    add_column :interviews, :calendar_uuid, :string
  end
end
