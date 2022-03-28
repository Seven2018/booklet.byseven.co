class UserTag < ApplicationRecord
  belongs_to :user
  belongs_to :tag
  belongs_to :tag_category
  validates_uniqueness_of :tag_category_id, scope: :user_id
  validate :same_company

  private

  def same_company
    errors.add(:base, 'a locked interview can not be changed') unless
      user.company_id == tag.company_id
  end
end
