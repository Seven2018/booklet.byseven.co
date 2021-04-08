class TagWorkshop < ApplicationRecord
  belongs_to :tag
  belongs_to :training_workshop
end
