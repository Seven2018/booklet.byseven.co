class Objective::Element < ApplicationRecord
  belongs_to :company
  has_many :objective_indicators, class_name: "Objective::Indicator", foreign_key: "objective_element_id", dependent: :destroy
end
