class Workshop < ApplicationRecord
  belongs_to :content
  has_many :sessions
  has_many :attendees, through: :sessions
  has_many :users, through: :attendees
  has_many :mods, dependent: :destroy
  has_many :assessments, dependent: :destroy
  validates :title, :duration, presence: true

  include PgSearch::Model
  pg_search_scope :search_workshops,
    against: [ :title ],
    using: {
      tsearch: { prefix: true }
    },
    ignoring: :accents

  def training
    sessions.map(&:training).first
  end

  def access_granted?
    session = sessions.order(date: :asc).first
    return session.date.present? && session.date <= Date.today && (session.available_date.nil? || session.available_date >= Date.today)
  end

  def synchronous?
    content.content_type == 'Synchronous'
  end

  def asynchronous?
    content.content_type == 'Asynchronous'
  end
end
