class AddPermissionsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :can_create_campaigns, :boolean, default: false, null: false
    add_column :users, :can_create_templates, :boolean, default: false, null: false
    add_column :users, :can_create_interview_reports, :boolean, default: false, null: false
    add_column :users, :can_read_contents, :boolean, default: false, null: false
    add_column :users, :can_create_contents, :boolean, default: false, null: false
    add_column :users, :can_create_trainings, :boolean, default: false, null: false
    add_column :users, :can_edit_training_workshops, :boolean, default: false, null: false
    add_column :users, :can_create_training_reports, :boolean, default: false, null: false
    add_column :users, :can_read_employees, :boolean, default: false, null: false
    add_column :users, :can_create_employees, :boolean, default: false, null: false
    add_column :users, :can_edit_employees, :boolean, default: false, null: false
  end
end
