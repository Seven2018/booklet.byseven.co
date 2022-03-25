# frozen_string_literal: true

class Icons::PeopleTrioComponent < Icons::BaseComponent
  def initialize(stroke: false, fill: false, height: nil, width: nil)
    super
    @fill = hexa[fill] || hexa[:orange]
    @width = width || '46'
    @height = height || '34'
  end
end
