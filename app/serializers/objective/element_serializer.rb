class Objective::ElementSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :due_date

  belongs_to :objectivable
end
