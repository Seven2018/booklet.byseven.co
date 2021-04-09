class TrainingWorkshop < ApplicationRecord
  belongs_to :training, optional: true
  belongs_to :workshop
  has_many :attendees, dependent: :destroy
  has_many :users, through: :attendees
  has_many :Tag_workshops, dependent: :destroy
  has_many :Tags, through: :Tag_workshops
  has_many :training_workshop_mods, dependent: :destroy
  has_many :mods, through: :training_workshop_mods
  validate :end_date_after_start_date

  def tag_ids
    tags = []
    self.users.map(&:tags).each do |tag|
      if Tag.first.users.count == self.users.joins(:user_tags).where(user_tags: {tag_id: tag}).count
        tags << tag
      end
    end
    tags.flatten(1).uniq.map(&:id)
  end

  def start_time
    self.date
  end

  def end_date_after_start_date
    status = true
    return status if available_date.blank?

    if available_date.present? && available_date < date
      errors.add(:available_date, "must be after the start date")
      status = false
    end
    status
  end
end
