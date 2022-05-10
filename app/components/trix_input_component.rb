# frozen_string_literal: true

class TrixInputComponent < ViewComponent::Base
  def initialize(name:, value:, placeholder:, klasses:, hide_toolbar: false, toolbar_within: false, auto_update: true, optional_data_action: '')
    @name = name
    @value = value
    @placeholder = placeholder
    @klasses = klasses
    @rand_uuid = "#{('a'..'z').to_a.sample}#{rand(10_000)}"
    @hide_toolbar = hide_toolbar
    @auto_update = auto_update
    @toolbar_within = toolbar_within
    @optional_data_action = optional_data_action
  end
end
