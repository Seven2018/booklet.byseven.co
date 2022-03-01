module Poro
  class Campaign
    def initialize(campaign:, employee_id:)
      @campaign = campaign
      @employee_id = employee_id
    end

    def employee_interview
      @campaign.interviews.where(employee_id: @employee_id).find(&:employee?)
    end

    def manager_interview
      @campaign.interviews.where(employee_id: @employee_id).find(&:manager?)
    end

    def crossed_interview
      @campaign.interviews.where(employee_id: @employee_id).find(&:crossed?)
    end
  end
end
