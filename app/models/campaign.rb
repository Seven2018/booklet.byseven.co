class Campaign < ApplicationRecord
  belongs_to :company
  belongs_to :owner, class_name: "User"
  belongs_to :interview_form
  has_many :interviews
  has_many :employees, through: :interviews
end
