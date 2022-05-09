class Objective::Indicator < ApplicationRecord
  belongs_to :objective_element, class_name: "Objective::Element"

  enum indicator_type: {
    boolean: 0,
    numeric_value: 10,
    percentage: 20,
    multi_choice: 30
  }
end
