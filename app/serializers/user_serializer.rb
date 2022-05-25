class UserSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :access_level_int,
    :email,
    :firstname,
    :lastname,
    :job_title,
    :picture,
    :gender,
    :objectives_count,
  )


  belongs_to :manager

  has_many :objective_elements

  def objectives_count
    object.objective_elements.count
  end

  def objective_elements
    if instance_options[:objective_elements_current]
      object.objective_elements.where(status: :opened)
    elsif instance_options[:objective_elements_archived]
      object.objective_elements.where(status: :archived)
    else
      object.objective_elements
    end
  end

  # def objective_elements_current
  #   object.objective_elements.where(status: :opened) if instance_options[:objective_elements_current]
  # end
  #
  # def objective_elements_archived
  #   object.objective_elements.where(status: :archived) if instance_options[:objective_elements_archived]
  # end
end
