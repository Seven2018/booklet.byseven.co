# frozen_string_literal: true

class Icons::ThreeCoinsComponent < Icons::BaseComponent
  def initialize(stroke: false, fill: false, height: nil, width: nil)
    super
    @fill = hexa[fill] || hexa[:orange]
    @width = width || '31'
    @height = height || '39'
  end
end
