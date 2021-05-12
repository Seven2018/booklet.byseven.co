class TrainingWorkshop < ApplicationRecord
  belongs_to :workshop
  has_many :attendees, dependent: :destroy
  has_many :users, through: :attendees
  has_many :Tag_workshops, dependent: :destroy
  has_many :Tags, through: :Tag_workshops
  has_many :training_workshop_mods, dependent: :destroy
  has_many :mods, through: :training_workshop_mods
  validates :date, :starts_at, :ends_at, presence: true
  validate :end_date_after_start_date
  has_rich_text :description

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

  def dates
    return {session0: {date: self.date, starts_at: self.starts_at, ends_at: self.ends_at}, session1: {date: self.date1, starts_at: self.starts_at1, ends_at: self.ends_at1}, session2: {date: self.date2, starts_at: self.starts_at2, ends_at: self.ends_at2}, session3: {date: self.date3, starts_at: self.starts_at3, ends_at: self.ends_at3}, session4: {date: self.date4, starts_at: self.starts_at4, ends_at: self.ends_at4}}
  end
end
