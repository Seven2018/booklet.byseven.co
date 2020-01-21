class TrainingProgram < ApplicationRecord
  belongs_to :company, optional: true
  has_many :trainings
  has_many :program_workshops, dependent: :destroy
  has_many :workshops, through: :program_workshops
  has_many :requests, dependent: :destroy

  def categories
    category_array = []
    self.workshops.each do |workshop|
      workshop.categories.each do |category|
        category_array << category
      end
    end
    category_array.uniq
  end
end
