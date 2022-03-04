# frozen_string_literal: true

module CampaignDrafts
  module Campaigns
    class Launch
      def self.call(**params)
        new(params).call
      end

      def initialize(campaign_draft:)
        @campaign_draft = campaign_draft
      end

      def call
        if create_interviews.all?(&:present?)
          campaign
        else
          campaign.destroy
          nil
        end
      end

      private

      def interview_form
        case @campaign_draft.templates_selection_method
        when 'single' then InterviewForm.find @campaign_draft.default_template_id
        # when 'multiple' then # TODO
        end
      end

      def owner
        case @campaign_draft.interviewer_selection_method
        when 'manager' then @campaign_draft.user
        # when 'multiple' then # TODO
        end
      end

      def campaign_type
        case @campaign_draft.kind
        when 'one_to_one' then 'one_to_one'
        # when 'feedback_360' then 'TODO'
        end
      end

      def campaign
        @campaign ||=
          Campaign.create(
            title: @campaign_draft.title,
            owner: owner,
            company: @campaign_draft.user.company,
            campaign_type: campaign_type
          )
      end

      def create_interview_set(interviewee)
        interviewer = interviewee.manager.present? ? interviewee.manager : User.find(@campaign_draft.default_interviewer_id)

        params =
          interview_params.merge(
            employee: interviewee,
            interviewer: interviewer,
            interview_form: interview_form
          )

        case interview_form.kind
        when :answerable_by_manager_not_crossed
          Interview.create(params.merge(label: 'Manager'))
        when :answerable_by_employee_not_crossed
          Interview.create(params.merge(label: 'Employee'))
        when :answerable_by_both_not_crossed
          Interview.create(params.merge(label: 'Employee')) &&
          Interview.create(params.merge(label: 'Manager'))
        when :answerable_by_both_crossed
          Interview.create(params.merge(label: 'Employee')) &&
          Interview.create(params.merge(label: 'Manager')) &&
          Interview.create(params.merge(label: 'Crossed'))
        else
          # will raise InterviewForm::UnknownKind
        end
      end

      def interviewees
        User.find @campaign_draft.interviewee_ids
      end

      def create_interviews
        interviewees.map do |interviewee|
          create_interview_set(interviewee)
        end
      end

      def interview_params
        {
          title: @campaign_draft.title,
          date: @campaign_draft.date,
          starts_at: @campaign_draft.starts_at,
          ends_at: @campaign_draft.ends_at,
          creator: campaign.owner,
          interview_form: campaign.interview_form,
          campaign: campaign
        }
      end
    end
  end
end
