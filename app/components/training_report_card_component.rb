# frozen_string_literal: true

class TrainingReportCardComponent < ViewComponent::Base
  def initialize(number:, metric:)
    @number = number
    @metric = metric
  end
end
