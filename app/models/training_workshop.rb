class TrainingWorkshop < ApplicationRecord
  belongs_to :training
  belongs_to :workshop

  def start_time
    self.date
  end
end
