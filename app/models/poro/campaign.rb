module Poro
  class Campaign
    def initialize(campaign:, employee_id:)
      @campaign = campaign
      @employee_id = employee_id
    end

    def crossed?
      [employee_interview, manager_interview, crossed_interview].all?(&:present?)
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

    def completed?
      [employee_interview, manager_interview, crossed_interview].compact.all?(&:completed?)
    end

    def locked?
      [employee_interview, manager_interview, crossed_interview].compact.all?(&:locked?)
    end
  end
end
