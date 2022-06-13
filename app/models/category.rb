class Category < ApplicationRecord
  belongs_to :company
  belongs_to :group_category
  has_many :content_categories, dependent: :destroy
  has_many :contents, through: :content_categories
  has_many :folder_categories, dependent: :destroy
  has_many :folders, through: :folder_categories
  has_and_belongs_to_many :campaigns, dependent: :destroy
  has_and_belongs_to_many :interview_forms, dependent: :destroy

  before_create :set_default_group

  enum kind: {
    interview: 0,
    training: 10,
  }

  def set_default_group
    return if self.group_category.present?

    group = GroupCategory.find_by(name: 'others')
    self.group_category = group if group.present?
  end
end
