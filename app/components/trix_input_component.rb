# frozen_string_literal: true

class TrixInputComponent < ViewComponent::Base
  def initialize(name:, value:, placeholder:, klasses:)
    @name = name
    @value = value
    @placeholder = placeholder
    @klasses = klasses
    @rand_uuid = "#{('a'..'z').to_a.sample}#{rand(10_000)}"
  end
end