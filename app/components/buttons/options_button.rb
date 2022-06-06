# frozen_string_literal: true

class Buttons::OptionsButton < ViewComponent::Base
  def initialize(vertical: false)
    @vertical = vertical
  end
end
