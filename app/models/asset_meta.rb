# frozen_string_literal: true

class AssetMeta
  class AssetMetableFormatError < StandardError; end
  attr_reader :width, :height

  def initialize(width:, height:)
    @width = width
    @height = height
  end

  def hint
    "w/h #{@width}/#{@height}px [crop: :fit, gravity: :center]"
  end
end
