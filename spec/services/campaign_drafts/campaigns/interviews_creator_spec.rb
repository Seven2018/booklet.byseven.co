require 'rails_helper'

describe CampaignDrafts::Campaigns::InterviewsCreator do
  subject do
    CampaignDrafts::Campaigns::InterviewsCreator.new(opts)
  end

  let(:company) { create(:company) }
  let!(:owner) { create(:user, email: Faker::Internet.email, company: company) }
  let!(:interviewee_manager) { create(:user, email: Faker::Internet.email) }
  let!(:interviewee) { create(:user, email: Faker::Internet.email, manager: interviewee_manager) }
  let(:opts) do
    {
      interviewee_ids: [interviewee.id],
      campaign_id: campaign.id,
      campaign_draft_id: campaign_draft.id
    }
  end
  let(:interviewee_ids) {[interviewee.id]}

  let!(:campaign_draft) do
    create(
      :campaign_draft,
      kind: 'one_to_one',
      data: data,
      user: owner
    )
  end
  let(:campaign) do
    create(:campaign,
           title: campaign_draft.title,
           owner: campaign_draft.user,
           company: campaign_draft.user.company,
           campaign_type: 'one_to_one',
           deadline: campaign_draft.date
          )
  end
  let(:template) { create(:interview_form, company: company, answerable_by: 'employee') }

  let(:data) do
    {
      title: 'a title',
      date: 30.days.from_now,
      kind: "one_to_one",
      starts_at: "09:00",
      ends_at: "10:00",
      interview_sets: [],
      interviewee_ids: interviewee_ids,

      default_template_id: template.id,
      default_interviewer_id: owner.id,
      templates_selection_method: "single",
      interviewee_selection_method: "manual",
      interviewer_selection_method: "manager"
    }
  end

  describe '#valid?' do
    context 'on campaign and campaign_draft' do
      it 'should be valid' do
        expect(subject.valid?).to eq(true)
      end
    end

    context 'without campaign and campaign_draft' do
      it 'should be valid' do
        invalid = CampaignDrafts::Campaigns::InterviewsCreator.new({})
        expect(invalid.valid?).to eq(false)
      end
    end
  end

  describe '#create' do
    it 'should add interview' do
      expect{ subject.create}.to change{ Interview.count }.by(1)
    end
  end
end
