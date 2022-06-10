# frozen_string_literal: true

class Tools::SelectComponent < ViewComponent::Base
  def initialize(width:, menu_max_height: '', title: '', input_name: '', collection: [], selected: '', data_action: '')
    @width = width
    @menu_max_height = menu_max_height
    @title = title
    @input_name = input_name
    @collection = collection
    @selected = @collection.include?(selected) ? selected : ''
    @data_action = data_action
  end
end
