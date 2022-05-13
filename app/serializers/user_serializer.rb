class UserSerializer < ActiveModel::Serializer
  attributes :id, :access_level_int, :email, :firstname, :lastname, :job_title, :picture, :gender, :objectives_count

  belongs_to :manager

  has_many :objective_elements

  def objectives_count
    object.objective_elements.count
  end
end
