class RefactorInterviewCompletedStatus < ActiveRecord::Migration[6.0]
  def up
    add_column :interviews, :status, :integer, default: 0

    Interview.where(completed: true).each do |interview|
      interview.update(status: :submitted)
    end
    Interview.where(completed: false).each do |interview|
      interview.update(status: :not_available_yet) if interview.crossed?
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
