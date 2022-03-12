# frozen_string_literal: true

class TrainingReportCardComponent < ViewComponent::Base
  def initialize(icon_klasses:, number:, metric:)
    @icon_klasses = icon_klasses
    @number = number
    @metric = metric
  end
end
