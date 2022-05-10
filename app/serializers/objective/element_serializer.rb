class Objective::ElementSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :due_date

  has_one :objective_indicator
  belongs_to :objectivable
end
