# frozen_string_literal: true

class BackComponent < ViewComponent::Base
  def initialize(fallback:)
    @fallback = fallback
  end
end
