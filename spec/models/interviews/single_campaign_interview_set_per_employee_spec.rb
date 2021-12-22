# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Interview, type: :model do
  let(:owner) { create(:user) }
  let(:employee) { create(:user, email: 'employee@gmail.com') }
  let(:interview_form) { create(:interview_form) }
  let(:campaign) do
    create(:campaign,
      title: interview_form.title,
      owner: owner,
      interview_form: interview_form,
      company: create(:company)
    )
  end

  let(:interview_params) do {
    title: interview_form.title,
    campaign: campaign,
    interview_form: interview_form,
    employee: employee,
    creator: owner
    }
  end

  describe '#single_campaign_interview_set_per_employee' do
    let(:new_employee_interview) { Interview.new(interview_params.merge(label: 'Employee')) }
    let(:new_hr_interview) { Interview.new(interview_params.merge(label: 'Manager')) }
    let(:new_crossed_interview) { Interview.new(interview_params.merge(label: 'Crossed')) }

    context 'when no campaign interview set exists for employee' do
      it 'interview can be created' do
        expect(campaign.interviews.count).to eq(0)
        expect(new_employee_interview.save).to be true
        expect(new_hr_interview.save).to be true
        expect(new_crossed_interview.save).to be true
        expect(campaign.interviews.count).to eq(3)
      end
    end

    context 'when a campaign interview set exists for employee' do
      before do
        create :interview, interview_params.merge(label: 'Employee')
        create :interview, interview_params.merge(label: 'Manager')
        create :interview, interview_params.merge(label: 'Crossed')
      end
      it 'interview can not be created but it can be updated' do
        expect(campaign.interviews.count).to eq(3)
        expect(new_employee_interview.save).to be false
        expect(new_hr_interview.save).to be false
        expect(new_crossed_interview.save).to be false
        expect(campaign.interviews.count).to eq(3)
        expect(campaign.interviews.first.valid?).to be true
      end
    end
  end
end
