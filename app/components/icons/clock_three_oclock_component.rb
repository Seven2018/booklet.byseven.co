# frozen_string_literal: true

class Icons::ClockThreeOclockComponent < Icons::BaseComponent
  def initialize(stroke: false, fill: false, height: nil, width: nil)
    super
    @fill = hexa[fill] || hexa[:orange]
    @width = width || '36'
    @height = height || '36'
  end
end
