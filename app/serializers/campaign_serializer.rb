class CampaignSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :title,
    :campaign_type,
    :employees_count,
    :completion
  )

  has_many :categories
  # has_many :employees, through: :interviews

  def employees_count
    object.employees.distinct.count
  end

  def completion
    return 0 if object.interviews.count.zero?

    return (object.interviews.submitted.count.fdiv(object.interviews.count) * 100).round

    # return 0 if object.interviews.where(employee: :all).count.zero?
    #
    # (
    #   object.interviews.submitted.where(employee: :all).count
    #             .fdiv(object.interviews.where(employee: :all).count) * 100
    # ).round
  end

end