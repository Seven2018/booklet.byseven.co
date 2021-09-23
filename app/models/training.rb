class Training < ApplicationRecord
  has_many :sessions, dependent: :destroy
  belongs_to :company
  belongs_to :folder, optional: true
  belongs_to :content, optional: true

  def past?
    past_sessions = []
    self.sessions.each do |session|
      if session.workshop.content_type == "Synchronous"
        past_sessions << self.id if session.date < Date.today
      elsif session.workshop.content_type == "Asynchronous"
        unless session.available_date.nil? || session.available_date > Date.today
          past_sessions << self.id
        end
      end
    end
    return past_sessions.count == self.sessions.count
  end

  def duration
    duration = 0
    self.sessions.each do |session|
      duration += session.workshop.duration
    end
    return duration == 0 ? 0 : time_conversion(duration)
  end

  def synchronous?
    self.sessions.any? { |session| session.workshop.content_type == "Synchronous"}
  end

  def asynchronous?
    self.sessions.any? { |session| session.workshop.content_type == "Asynchronous"}
  end

  def next_session
    self.sessions.where('date > ?', Date.today).order(date: :asc).first
  end

  private

  def time_conversion(minutes)
    hours = minutes / 60
    rest = minutes % 60
    return "#{hours}h#{rest unless rest == 0}"
  end
end
