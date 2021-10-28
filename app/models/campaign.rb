class Campaign < ApplicationRecord
  belongs_to :company
  belongs_to :creator, class_name: "User"
end
