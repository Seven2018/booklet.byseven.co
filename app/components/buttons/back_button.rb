# frozen_string_literal: true

class Buttons::BackButton < ViewComponent::Base
  def initialize(fallback:)
    @fallback = fallback
  end
end
