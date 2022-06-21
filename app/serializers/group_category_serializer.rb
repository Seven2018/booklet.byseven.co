class GroupCategorySerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :categories
end
