class Mod < ApplicationRecord
  belongs_to :content, optional: true
  belongs_to :workshop, optional: true
  has_many :assessment_questions, dependent: :destroy
  has_many :user_forms, dependent: :destroy
  validates :title, presence: true
  has_rich_text :text

  def text?
    mod_type == 'text'
  end

  def video?
    mod_type == 'video'
  end

  def assessment?
    mod_type == 'assessment'
  end
end
