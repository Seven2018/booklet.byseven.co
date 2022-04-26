class RefactorInterviewCompletedStatus < ActiveRecord::Migration[6.0]
  def up
    add_column :interviews, :status, :integer, default: 0

    Interview.where(completed: true).each do |interview|
      interview.update(status: :submitted, locked_at: DateTime.now)
    end
    Interview.where(label: 'Crossed', completed: false).each do |interview|
      set = interview.set

      unless [set.employee_interview&.submitted?, set.manager_interview&.submitted?].compact.uniq == [true]
        interview.update(status: 'not_available_yet')
      end
    end

    remove_column :interviews, :completed
  end

  def down
    add_column :interviews, :completed, :boolean, default: false

    Interview.where(status: :submitted).each do |interview|
      interview.update(completed: true, locked_at: nil)
    end

    remove_column :interviews, :status
  end
end
