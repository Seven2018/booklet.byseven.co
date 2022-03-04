module Poro
  class Campaign
    def initialize(campaign:, employee_id:)
      @campaign = campaign
      @employee_id = employee_id
    end

    def crossed?
      @campaign.interviews.where(employee_id: @employee_id).pluck(:label).sort == %w[Crossed Employee Manager]
    end

    def employee_interview
      @campaign.interviews.where(employee_id: @employee_id).find(&:employee?)&.decorate
    end

    def manager_interview
      @campaign.interviews.where(employee_id: @employee_id).find(&:simple?)&.decorate  ||
        @campaign.interviews.where(employee_id: @employee_id).find(&:manager?)&.decorate
    end

    def crossed_interview
      @campaign.interviews.where(employee_id: @employee_id).find(&:crossed?)&.decorate
    end
  end
end
