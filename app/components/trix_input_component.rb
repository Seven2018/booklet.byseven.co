# frozen_string_literal: true

class TrixInputComponent < ViewComponent::Base
  def initialize(name:, value:, placeholder:)
    @name = name
    @value = value
    @placeholder = placeholder
    @rand_uuid = "#{('a'..'z').to_a.sample}#{rand(10_000)}"
  end
end
