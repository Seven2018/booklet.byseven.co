class Workshop < ApplicationRecord
  belongs_to :content
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

  def access_granted?
    session = self.session
    return session.date.present? && session.date <= Date.today && (session.available_date.nil? || session.available_date >= Date.today)
  end
end
