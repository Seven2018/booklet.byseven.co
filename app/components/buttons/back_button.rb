# frozen_string_literal: true

class Buttons::BackButton < ViewComponent::Base
  def initialize(fallback:, force_fallback: false)
    @fallback = fallback
    @force_fallback = force_fallback
  end
end
