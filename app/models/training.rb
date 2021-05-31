class Training < ApplicationRecord
  has_many :sessions
  belongs_to :company
  belongs_to :folder, optional: true
  belongs_to :content, optional: true
end
