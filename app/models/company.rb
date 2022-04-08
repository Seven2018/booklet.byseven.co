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

  has_one_attached :clear_bg_logo
  has_one_attached :dark_bg_logo
  has_one_attached :my_interviews_bg_picture
  has_one_attached :my_team_interviews_bg_picture
  has_one_attached :my_trainings_bg_picture
  has_one_attached :my_team_trainings_bg_picture

  serialize :applications, Hash

  include Companies::AssetsMeta
  include Companies::Applications

  def default_tag_category
    tag_categories.order('RANDOM()').first.presence ||
      TagCategory.create(company: self, name: 'Job Title', position: 1)
  end
end
