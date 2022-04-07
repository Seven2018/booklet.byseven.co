# frozen_string_literal: true

class ToggleSwitch < ViewComponent::Base
  def initialize(name:, checked:)
    @name = name
    @checked = checked
  end
end
