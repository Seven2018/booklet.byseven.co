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

  def self.default_group_for(kind)
    find_by(name: 'others', kind: kind)
  end
end
