class Objective::Log < ApplicationRecord
  belongs_to :owner, class_name: 'User', optional: true
  belongs_to :objective_element, class_name: "Objective::Element"
  belongs_to :objective_indicator, class_name: "Objective::Indicator"
end
