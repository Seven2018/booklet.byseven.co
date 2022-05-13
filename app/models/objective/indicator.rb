class Objective::Indicator < ApplicationRecord
  belongs_to :objective_element, class_name: "Objective::Element"
  has_many :objective_logs, class_name: "Objective::Log", foreign_key: "objective_indicator_id", dependent: :destroy

  enum indicator_type: {
    boolean: 0,
    numeric_value: 10,
    percentage: 20,
    multi_choice: 30
  }

  enum status: {
    not_completed: 0,
    in_progress: 50,
    completed: 100
  }
end
