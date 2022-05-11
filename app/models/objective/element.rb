class Objective::Element < ApplicationRecord
  belongs_to :company
  belongs_to :creator, class_name: 'User', optional: true
  belongs_to :objectivable, polymorphic: true

  has_one :objective_indicator, class_name: "Objective::Indicator", foreign_key: "objective_element_id", dependent: :destroy
  has_many :objective_logs, class_name: "Objective::Log", foreign_key: "objective_element_id", dependent: :destroy

  enum status: {
    opened: 0,
    archived: 10
  }

  def employee
    objectivable_type == 'User' ? User.find(objectivable_id) : nil
  end

  def manager
    objectivable_type == 'User' ? employee.manager : nil
  end

end
