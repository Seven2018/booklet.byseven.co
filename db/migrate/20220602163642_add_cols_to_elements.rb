class AddColsToElements < ActiveRecord::Migration[6.0]
  def change
    add_column :objective_elements, :template, :boolean, default: false
    add_column :objective_elements, :can_employee_edit, :boolean, default: true
    add_column :objective_elements, :can_employee_view, :boolean, default: true
  end
end