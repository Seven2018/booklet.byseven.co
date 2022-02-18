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
      company: create(:company),
      campaign_type: campaign_type
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

  let(:interview) { Interview.new(interview_params.merge(label: label)) }

  describe '#label_and_campaign_type_match' do
    context 'with a crossed campaign' do
      let(:campaign_type) { :crossed }

      context 'with a Employee label' do
        let(:label) { 'Employee' }
        it 'an interview can be created' do
          expect(interview.save).to be true
        end
      end

      context 'with a Manager label' do
        let(:label) { 'Manager' }
        it 'an interview can be created' do
          expect(interview.save).to be true
        end
      end

      context 'with a Crossed label' do
        let(:label) { 'Crossed' }
        it 'an interview can be created' do
          expect(interview.save).to be true
        end
      end

      context 'with a simple label' do
        let(:label) { 'Simple' }
        it 'an interview can NOT be created' do
          expect(interview.save).to be false
        end
      end
    end

    context 'with a simple campaign' do
      let(:campaign_type) { :simple }

      context 'with a Employee label' do
        let(:label) { 'Employee' }
        it 'an interview can NOT be created' do
          expect(interview.save).to be false
        end
      end

      context 'with a Manager label' do
        let(:label) { 'Manager' }
        it 'an interview can NOT be created' do
          expect(interview.save).to be false
        end
      end

      context 'with a Crossed label' do
        let(:label) { 'Crossed' }
        it 'an interview can NOT be created' do
          expect(interview.save).to be false
        end
      end

      context 'with a simple label' do
        let(:label) { 'Simple' }
        it 'an interview can be created' do
          expect(interview.save).to be true
        end
      end
    end
  end
end
