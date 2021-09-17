class Workshop < ApplicationRecord
  belongs_to :content
  has_one :session
end
