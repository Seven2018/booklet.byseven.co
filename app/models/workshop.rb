class Workshop < ApplicationRecord
  belongs_to :content
  has_one :session
  has_many :mods, dependent: :destroy
  has_many :assessments, dependent: :destroy
  validates :title, :duration, presence: true

  def access_granted?
    session = self.session
    return session.date.present? && session.date <= Date.today && (session.available_date.nil? || session.available_date >= Date.today)
  end
end
