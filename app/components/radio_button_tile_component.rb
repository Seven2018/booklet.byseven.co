# frozen_string_literal: true

class RadioButtonTileComponent < ViewComponent::Base
  def initialize(model:, name:, checked:, icon_klasses:, title:, subtitle:, disabled: false, compact: false)
    @model = model
    @name = name
    @checked = checked
    @icon_klasses = icon_klasses
    @title = title
    @subtitle = subtitle
    @disabled = disabled
    @compact = compact
  end

  def model_name
    "#{@model}_#{@name}".to_sym
  end

  def toggle_all_event
    "toggle_all_#{@model}"
  end
end