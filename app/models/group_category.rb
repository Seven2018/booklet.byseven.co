class GroupCategory < ApplicationRecord
  belongs_to :company

  has_many :categories

  enum kind: {
    interview: 0,
    training: 10,
  }

  def self.of_kind(kind)
    where(kind: kind)
  end
end
