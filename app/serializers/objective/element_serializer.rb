class Objective::ElementSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :due_date, :comments_count, :updated_at, :can_employee_edit, :can_employee_view

  has_one :objective_indicator
  belongs_to :objectivable

  def comments_count
    object.objective_logs.where.not(comments: nil).count
  end
end
