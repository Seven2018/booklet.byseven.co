class Mod < ApplicationRecord
  belongs_to :content, optional: true
  belongs_to :workshop, optional: true
  has_many :assessment_questions, dependent: :destroy
  has_many :user_forms, dependent: :destroy
  validates :title, presence: true
  has_rich_text :text
  validate :valid_video

  private

  def valid_video
    return true if video.blank?

    return true if video.include? 'www.youtube.com/watch?v='

    errors.add(:video, 'invalid video link')
  end
end
