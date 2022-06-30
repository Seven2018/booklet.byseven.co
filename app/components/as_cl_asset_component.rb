# frozen_string_literal: true

# ActiveStorage Cloudinary Asset Component
class AsClAssetComponent < ViewComponent::Base
  def initialize(model:, asset:, style: nil, class_name: '', fallback: nil)
    @model = model
    @asset = asset
    @style = style
    @class_name = class_name
    @fallback = fallback
  end

  def asset
    @model.send @asset
  end

  def asset_meta(size)
    @model.send "#{@asset}_meta", size
  end
end
