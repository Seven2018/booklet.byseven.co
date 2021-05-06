class AddMultipleDatesToTrainingWorkshop < ActiveRecord::Migration[6.0]
  def change
    add_column :training_workshops, :date1, :datetime
    add_column :training_workshops, :date2, :datetime
    add_column :training_workshops, :date3, :datetime
    add_column :training_workshops, :date4, :datetime
    add_column :training_workshops, :starts_at1, :time
    add_column :training_workshops, :starts_at2, :time
    add_column :training_workshops, :starts_at3, :time
    add_column :training_workshops, :starts_at4, :time
    add_column :training_workshops, :ends_at1, :time
    add_column :training_workshops, :ends_at2, :time
    add_column :training_workshops, :ends_at3, :time
    add_column :training_workshops, :ends_at4, :time
  end
end
