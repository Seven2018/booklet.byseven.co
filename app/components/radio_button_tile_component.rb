# frozen_string_literal: true

class RadioButtonTileComponent < ViewComponent::Base
  def initialize(model:, name:, checked:, title:, subtitle:,
      disabled: false, compact: false, data_actions: false, data_attributes: {}, checked_color: 'dark-blue')
    @model = model
    @name = name
    @checked = checked
    @title = title
    @subtitle = subtitle
    @disabled = disabled
    @compact = compact
    @data_actions = data_actions
    @data_attributes = data_attributes
    @checked_color = checked_color
  end

  def model_name
    "#{@model}_#{@name}".to_sym
  end

  def toggle_all_event
    "toggle_all_#{@model}"
  end
end
