class TeamWorkshop < ApplicationRecord
  belongs_to :team
  belongs_to :training_workshop
end
