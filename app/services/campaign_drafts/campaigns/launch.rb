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

      def interviewees
        User.find @campaign_draft.interviewee_ids
      end

      def create_interviews
        interviewees.map do |interviewee|
          interviewer = interviewee.manager.presence || User.find(@campaign_draft.default_interviewer_id)
          InterviewSets::Create.call interview_params.merge(employee: interviewee, interviewer: interviewer)
        end
      end

      def interview_params
        {
          title: @campaign_draft.title,
          date: @campaign_draft.date,
          starts_at: @campaign_draft.starts_at,
          ends_at: @campaign_draft.ends_at,
          creator: campaign.owner,
          interview_form: interview_form,
          campaign: campaign
        }
      end
    end
  end
end
