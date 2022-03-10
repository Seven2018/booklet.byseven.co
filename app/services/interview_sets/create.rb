# frozen_string_literal: true

module InterviewSets
  class Create
    def self.call(**params)
      new(params).call
    end

    def initialize(employee:, interviewer:, interview_form:, title:, date:,
      starts_at:, ends_at:, creator:, campaign:)
      @employee = employee
      @interviewer = interviewer
      @interview_form = interview_form
      @title = title
      @date = date
      @starts_at = starts_at
      @ends_at = ends_at
      @creator = creator
      @campaign = campaign
    end

    def call
      case @interview_form.kind
      when :answerable_by_manager_not_crossed
        Interview.create(interview_params.merge(label: 'Manager'))
      when :answerable_by_employee_not_crossed
        Interview.create(interview_params.merge(label: 'Employee'))
      when :answerable_by_both_not_crossed
        Interview.create(interview_params.merge(label: 'Employee')) &&
        Interview.create(interview_params.merge(label: 'Manager'))
      when :answerable_by_both_crossed
        Interview.create(interview_params.merge(label: 'Employee')) &&
        Interview.create(interview_params.merge(label: 'Manager')) &&
        Interview.create(interview_params.merge(label: 'Crossed'))
      else
        # will raise InterviewForm::UnknownKind
      end
    end

    private

    def interview_params
      {
        employee: @employee,
        interviewer: @interviewer,
        interview_form: @interview_form,
        title: @title,
        date: @date,
        starts_at: @starts_at,
        ends_at: @ends_at,
        creator: @creator,
        campaign: @campaign
      }
    end
  end
end
