class Training < ApplicationRecord
  validates :category, inclusion: { in: ['Sales', 'Product', 'Side Management', 'Management'] }
end
