class Training < ApplicationRecord
  belongs_to :company
  belongs_to :training_program, optional: true
  has_many :training_workshops, dependent: :destroy
  has_many :workshops, through: :training_workshops

  def attendees
    attendees = []
    self.training_workshops.each do |workshop|
      attendees << workshop.attendees
    end
    attendees.flatten(1).uniq
  end

  def users
    users = []
    self.training_workshops.each do |workshop|
      users << workshop.users
    end
    users.flatten(1).uniq
  end

  def user_ids
    users = []
    self.training_workshops.each do |workshop|
      users << workshop.users
    end
    users.flatten(1).uniq.map(&:id)
  end

  def last_date
    date_array =[]
    self.training_workshops.each do |workshop|
      date_array << workshop.date
    end
    date_array.sort.last
  end

  def first_date
    date_array =[]
    self.training_workshops.each do |workshop|
      date_array << workshop.date
    end
    date_array.sort.first
  end

  def next_date
    date_array =[]
    self.training_workshops.each do |workshop|
      date_array << workshop.date if workshop.date >= Date.today
    end
    date_array.sort.first
  end
end
