class RefactorInterviewCompletedStatus < ActiveRecord::Migration[6.0]
  def up
    add_column :interviews, :status, :integer, default: 0

    Interview.where(completed: true).each do |interview|
      interview.update_columns(status: :submitted)
      
      if interview.locked_at.nil?
        interview.update_columns(locked_at: DateTime.now)
      else
        interview.update_columns(locked_at: interview.locked_at)
      end
    end
    Interview.where(label: 'Crossed', completed: false).each do |interview|
      set = interview.set

      unless [set.employee_interview&.submitted?, set.manager_interview&.submitted?].compact.uniq == [true]
        interview.update(status: :not_available_yet)
      end
    end

    remove_column :interviews, :completed
  end

  def down
    add_column :interviews, :completed, :boolean, default: false

    Interview.where(status: :submitted).each do |interview|
      interview.update(completed: true)
    end

    remove_column :interviews, :status
  end
end
