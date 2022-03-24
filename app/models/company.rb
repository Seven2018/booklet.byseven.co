class Company < ApplicationRecord
  has_many :users
  has_many :contents
  has_many :trainings
  has_many :sessions
  has_many :tag_categories, dependent: :destroy
  has_many :interview_reports, dependent: :destroy
  has_many :training_reports, dependent: :destroy
  has_many :campaigns, dependent: :destroy

  validates :siret, presence: true, length: { is: 14 }
  validates :siret, uniqueness: true

  def default_tag_category
    tag_categories.order('RANDOM()').first.presence ||
      TagCategory.create(company: self, name: 'Job Title', position: 1)
  end
end
