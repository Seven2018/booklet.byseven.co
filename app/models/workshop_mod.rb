class WorkshopMod < ApplicationRecord
  belongs_to :workshop
  belongs_to :mod
  validates_uniqueness_of :mod_id, scope: :workshop_id
end
