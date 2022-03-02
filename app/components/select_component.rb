# frozen_string_literal: true

class SelectComponent < ViewComponent::Base
  def initialize(width:, title:)
    @width = width
    @title = title
  end
end
