class WorkshopCategory < ApplicationRecord
  belongs_to :workshop
  belongs_to :category
end
