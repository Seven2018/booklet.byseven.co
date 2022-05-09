class Objective::Element < ApplicationRecord
  belongs_to :company
  belongs_to :objectivable, polymorphic: true
  has_one :objective_indicator, class_name: "Objective::Indicator", foreign_key: "objective_element_id", dependent: :destroy
end
