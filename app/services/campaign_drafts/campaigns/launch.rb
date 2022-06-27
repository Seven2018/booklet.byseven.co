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
        campaign
        create_interviews
        @campaign.categories << @campaign.interview_forms.map(&:categories).flatten.uniq
        @campaign
      end

      private

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
            owner: @campaign_draft.user,
            company: @campaign_draft.user.company,
            campaign_type: campaign_type,
            deadline: @campaign_draft.date
        )
      end

      def create_interviews
        attach_campaign
        opts = {}.tap do |attrs|
          attrs['interviewee_ids'] = @campaign_draft.interviewee_ids
          attrs['campaign_id'] = campaign&.id
          attrs['campaign_draft_id'] = @campaign_draft.id
        end
        CampaignDrafts::Campaigns::InterviewsCreatorWorker.perform_async(opts)
      end

      def attach_campaign
        new_data = @campaign_draft.data.merge('campaign_id': @campaign.id)
        @campaign_draft.update(data: new_data)
      end
    end
  end
end
