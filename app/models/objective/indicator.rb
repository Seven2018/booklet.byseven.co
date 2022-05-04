class Objective::Indicator < ApplicationRecord
  belongs_to: :objective_element

  enum campaign_type: {
    boolean: 0,
    numeric_value: 10,
    percentage: 20,
    multi_choice: 30
  }
end
