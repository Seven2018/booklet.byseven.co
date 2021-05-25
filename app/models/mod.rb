class Mod < ApplicationRecord
  belongs_to :content
  has_many :assessment_questions, dependent: :destroy
  has_many :user_forms, dependent: :destroy
  has_rich_text :text
end
