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
        when 'single' then
          template = InterviewForm.find @campaign_draft.default_template_id
          new_form = InterviewForm.create(
            template.attributes.except('id', 'created_at', 'updated_at').merge(used: true, categories: template.categories)
          )

          template.interview_questions.order(position: :asc).each do |question|
            InterviewQuestion.create \
              question.attributes
                      .except('id', 'interview_form_id', 'position', 'created_at', 'updated_at')
                      .merge(interview_form: new_form, position: question.position)
          end

          # TODO : Tag system update incoming
          template.interview_form_tags.each do |tag|
            InterviewFormTag.create \
              tag.attributes
                 .except('id', 'interview_form_id', 'created_at', 'updated_at')
                 .merge(interview_form: new_form)
          end

          return new_form
        # when 'multiple' then # TODO
        end
      end

      def interviewer(interviewee)
        case @campaign_draft.interviewer_selection_method
        when 'manager' then
          interviewee.manager.presence || @campaign_draft.default_interviewer
        when 'specific_manager' then
          @campaign_draft.default_interviewer
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
            owner: @campaign_draft.user,
            company: @campaign_draft.user.company,
            campaign_type: campaign_type
          )
      end

      def interviewees
        User.find @campaign_draft.interviewee_ids
      end

      def create_interviews
        interviewees.map do |interviewee|
          InterviewSets::Create.call(
            interview_params.merge(
              employee: interviewee,
              interviewer: interviewer(interviewee)
            )
          )
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
