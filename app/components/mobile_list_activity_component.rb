
class MobileListActivityComponent < ViewComponent::Base
  def initialize(title:, list:, id:, data:)
    @title = title
    @list = list
    @id = id
    @data = data
  end
end