
class MobileBoxStatusFormComponent < ViewComponent::Base
  def initialize(emoji:, nbr:, subtitle:, bg:, color:, data:)
    @emoji = emoji
    @nbr = nbr
    @subtitle = subtitle
    @bg = bg
    @color = color
    @data = data
  end
end