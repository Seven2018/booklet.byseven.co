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
          @campaign.categories << @campaign.interview_forms.map(&:categories).flatten.uniq
          @campaign
        else
          campaign.destroy
          nil
        end
      end

      private

      def interview_form
        case @campaign_draft.templates_selection_method

        when 'single'
          return create_form_from(@campaign_draft.default_template_id)

        when 'multiple'
          forms = {}

          @campaign_draft.multi_templates_ids.each do |pair|
            pair = pair.split(':')

            forms[pair.first] = create_form_from(pair.last).id
          end

          return forms

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
            campaign_type: campaign_type,
            deadline: @campaign_draft.date
          )
      end

      def interviewees
        User.find @campaign_draft.interviewee_ids
      end

      def create_interviews
        forms = interview_form
        multiple = forms.class == Hash

        interviewees.map do |interviewee|
          if multiple
            selected_form =
              InterviewForm.find(forms[UserTag.find_by(user_id: interviewee, tag_id: forms.keys)&.tag_id&.to_s].presence \
               || @campaign_draft.default_template_id)
          else
            selected_form = forms
          end

          InterviewSets::Create.call(
            interview_params.merge(
              employee: interviewee,
              interviewer: interviewer(interviewee),
              interview_form: selected_form
            )
          )
        end
      end

      def interview_params
        {
          title: @campaign_draft.title,
          creator: campaign.owner,
          campaign: campaign
        }
      end

      def create_form_from(template_id)
        template = InterviewForm.find template_id

        new_form = InterviewForm.create(
          template.attributes.except('id', 'created_at', 'updated_at').merge(used: true, categories: template.categories)
        )

        template.interview_questions.order(position: :asc).each do |question|
          InterviewQuestion.create \
            question.attributes
                    .except('id', 'interview_form_id', 'position', 'created_at', 'updated_at')
                    .merge(interview_form: new_form, position: question.position)
        end

        template.categories.each do |category|
          new_form.categories << category
        end

        return new_form
      end
    end
  end
end
