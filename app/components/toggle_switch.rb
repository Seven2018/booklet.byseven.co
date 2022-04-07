# frozen_string_literal: true

class ToggleSwitch < ViewComponent::Base
  def initialize(name:, checked:, remember_initial_state: false)
    @name = name
    @checked = checked
    @remember_initial_state = remember_initial_state
  end
end
