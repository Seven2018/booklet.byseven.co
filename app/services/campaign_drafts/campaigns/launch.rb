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
        when 'multiple' then # TODO
        end
      end

      def owner
        case @campaign_draft.interviewer_selection_method
        when 'manager' then User.find @campaign_draft.default_interviewer_id
        when 'multiple' then # TODO
        end
      end

      def campaign_type
        case @campaign_draft.kind
        when 'one_to_one' then 'crossed'
        when 'feedback_360' then 'TODO'
        when 'TODO' then 'simple'
        end
      end

      def campaign
        @campaign ||=
          Campaign.create(
            title: @campaign_draft.title,
            interview_form: interview_form,
            owner: owner,
            company: @campaign_draft.user.company,
            campaign_type: campaign_type
          )
      end

      def create_interview_set(interviewee)
        (
          campaign.crossed? &&
          Interview.create(interview_params.merge(employee: interviewee, label: 'Employee')) &&
          Interview.create(interview_params.merge(employee: interviewee, label: 'Manager')) &&
          Interview.create(interview_params.merge(employee: interviewee, label: 'Crossed'))
        ) || (
          campaign.simple? &&
          Interview.create(interview_params.merge(employee: interviewee, label: 'Simple'))
        )
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
          title: campaign.interview_form.title,
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
