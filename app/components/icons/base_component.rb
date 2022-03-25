# frozen_string_literal: true

class Icons::BaseComponent < ViewComponent::Base
  def initialize(stroke: false, fill: false, height: nil, width: nil)
    @fill = hexa[fill] || 'none'
    @stroke = hexa[stroke] || hexa[:orange]
    @width = width || '50'
    @height = height || '50'
  end

  private

  def hexa
    # WARNING hexadecimal source of truth  => _colors.scss
    {
      orange: '#EF8C64',
      blue: '#3177B7'
    }
  end
end
