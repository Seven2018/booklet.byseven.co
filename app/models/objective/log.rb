class Objective::Log < ApplicationRecord
  belongs_to :owner, class_name: 'User', optional: true
  belongs_to :objective_element, class_name: "Objective::Element"
  belongs_to :objective_indicator, class_name: "Objective::Indicator", optional: true

  enum log_type: {
    no_update: 0,
    title_updated: 1,
    description_updated: 2,
    value_updated: 3
  }
end
