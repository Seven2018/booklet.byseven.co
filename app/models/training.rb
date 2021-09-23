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
end
