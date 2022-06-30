module CampaignDrafts
  module Campaigns
    class InterviewsCreator
      def initialize(opts={})
        @campaign_draft_id = opts['campaign_draft_id']
        @campaign_id = opts['campaign_id']
        @interviewee_ids = opts['interviewee_ids']
      end

      def valid?
        campaign_draft.present? && campaign.present?
      end

      def create
        forms = interview_form
        multiple = forms.class == Hash
        User.where(id: @interviewee_ids).find_in_batches do |interviewee_group|
          interviewee_group.each do |interviewee|
            if multiple
              selected_form =
                InterviewForm.find(forms[UserTag.find_by(user_id: interviewee, tag_id: forms.keys)&.tag_id&.to_s].presence \
                                   || forms['default'])
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
        @campaign_draft.destroy
        send_mail
      end

      def send_mail
        owner = User.find_by(id: @campaign.owner_id)
        CampaignMailer.campaign_interview_created(owner, @campaign)
                      .deliver_later

        if @campaign_draft.send_invitation
          interviewers = @campaign.interviewers.uniq
          interviewees = @campaign.employees.uniq

          interviewers.each do |interviewer|
            CampaignMailer.with(user: interviewer)
              .invite_interviewer(interviewer, @campaign)
              .deliver_later
          end

          interviewees.each do |interviewee|
            interview = Interview.find_by(campaign: @campaign, employee: interviewee, label: 'Employee')
            interviewer = interview.interviewer

            CampaignMailer.with(user: interviewee)
              .invite_employee(interviewer, interviewee, interview)
              .deliver_later
          end
        end
      end

      private

      def campaign
        @campaign ||= Campaign.find_by(id: @campaign_id)
      end

      def campaign_draft
        @campaign_draft ||= CampaignDraft.find_by(id: @campaign_draft_id)
      end

      def interview_form
        case campaign_draft.templates_selection_method

        when 'single'
          return create_form_from(campaign_draft.default_template_id)

        when 'multiple'
          forms = {}
          campaign_draft.multi_templates_ids.each do |pair|
            pair = pair.split(':')
            forms[pair.first] = create_form_from(pair.last).id
          end
          forms['default'] = create_form_from(campaign_draft.default_template_id).id
          return forms
        end
      end

      def create_form_from(template_id)
        template = InterviewForm.find template_id

        new_form = InterviewForm.create(
          template.attributes.except('id', 'created_at', 'updated_at').merge(used: true)
        )

        template.interview_questions.order(position: :asc).each do |question|
          InterviewQuestion.create \
            question.attributes
            .except('id', 'interview_form_id', 'position', 'created_at', 'updated_at')
            .merge(interview_form: new_form, position: question.position)
        end

        new_form.categories = template.categories

        return new_form
      end

      def interviewer(interviewee)
        case campaign_draft.interviewer_selection_method
        when 'manager' then
          interviewee.manager.presence || campaign_draft.default_interviewer
        when 'specific_manager' then
          campaign_draft.default_interviewer
        end
      end

      def interview_params
        {
          title: campaign_draft.title,
          creator: campaign.owner,
          campaign: campaign
        }
      end
    end
  end
end
