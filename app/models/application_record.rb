class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.get_activerecord_relation(arr)
    where(id: arr.map(&:id))
  end
end
