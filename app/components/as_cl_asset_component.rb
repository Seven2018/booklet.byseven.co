# frozen_string_literal: true

# ActiveStorage Cloudinary Asset Component
class AsClAssetComponent < ViewComponent::Base
  def initialize(model:, asset:, style: nil, class_name: '')
    @model = model
    @asset = asset
    @style = style
    @class = class_name
  end

  def asset
    @model.send @asset
  end

  def asset_meta(size)
    @model.send "#{@asset}_meta", size
  end
end
