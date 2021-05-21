class ContentCategory < ApplicationRecord
  belongs_to :content
  belongs_to :category
  validates_uniqueness_of :category_id, scope: :content_id
end
