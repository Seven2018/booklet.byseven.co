
class HomeFieldComponent < ViewComponent::Base
  def initialize(color:, path:, title:, nbr:)
    @color = color
    @path = path
    @title = title
    @nbr = nbr
  end
end