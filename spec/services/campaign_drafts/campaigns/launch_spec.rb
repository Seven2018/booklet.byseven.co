# frozen_string_literal: true

require 'rails_helper'

describe CampaignDrafts::Campaigns::Launch do
  subject do
    CampaignDrafts::Campaigns::Launch.call(campaign_draft: campaign_draft)
  end

  let(:company) { create(:company) }
  let!(:owner) { create(:user, email: Faker::Internet.email, company: company) }
  let!(:interviewee_manager) { create(:user, email: Faker::Internet.email) }
  let!(:interviewee) { create(:user, email: Faker::Internet.email, manager: interviewee_manager) }

  let!(:campaign_draft) do
    create(
      :campaign_draft,
      kind: 'one_to_one',
      data: data,
      user: owner
    )
  end

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

  context 'with one interviewee' do
    let(:interviewee_ids) { [interviewee.id] }
    context 'with interview_form answerable_by employee' do
      let(:template) { create(:interview_form, answerable_by: 'employee') }
      it 'should create a campaign and well formed interviews sets' do
        subject
        expect(Campaign.count).to eq 1
        Campaign.first.interview_sets.each do |set|
          expect(set.employee_interview.present?).to eq true
          expect(set.manager_interview.present?).to eq false
          expect(set.crossed_interview.present?).to eq false
        end
      end
    end

    context 'with interview_form answerable_by manager' do
      let(:template) { create(:interview_form, answerable_by: 'manager') }
      it 'should create a campaign and well formed interviews sets' do
        subject
        expect(Campaign.count).to eq 1
        Campaign.first.interview_sets.each do |set|
          expect(set.employee_interview.present?).to eq false
          expect(set.manager_interview.present?).to eq true
          expect(set.crossed_interview.present?).to eq false
        end
      end
    end

    context 'with interview_form answerable_by both' do
      context 'and not crossed' do
        let(:template) { create(:interview_form, answerable_by: 'both') }
        it 'should create a campaign and well formed interviews sets' do
          subject
          expect(Campaign.count).to eq 1
          Campaign.first.interview_sets.each do |set|
            expect(set.employee_interview.present?).to eq true
            expect(set.manager_interview.present?).to eq true
            expect(set.crossed_interview.present?).to eq false
          end
        end
      end

      context 'and crossed' do
        let(:template) { create(:interview_form, answerable_by: 'both', cross: true) }
        it 'should create a campaign and well formed interviews sets' do
          subject
          expect(Campaign.count).to eq 1
          Campaign.first.interview_sets.each do |set|
            expect(set.employee_interview.present?).to eq true
            expect(set.manager_interview.present?).to eq true
            expect(set.crossed_interview.present?).to eq true
          end
        end
      end
    end
  end

  context 'with 3 interviewees' do
    let(:interviewee_ids) do
      [
        interviewee.id,
        create(:user, email: Faker::Internet.email).id,
        create(:user, email: Faker::Internet.email).id
      ]
    end

    context 'with interview_form answerable_by employee' do
      let(:template) { create(:interview_form, answerable_by: 'employee') }
      it 'should create a campaign and well formed interviews sets' do
        subject
        expect(Campaign.count).to eq 1
        Campaign.first.interview_sets.each do |set|
          expect(set.employee_interview.present?).to eq true
          expect(set.manager_interview.present?).to eq false
          expect(set.crossed_interview.present?).to eq false
        end
      end
    end

    context 'with interview_form answerable_by manager' do
      let(:template) { create(:interview_form, answerable_by: 'manager') }
      it 'should create a campaign and well formed interviews sets' do
        subject
        expect(Campaign.count).to eq 1
        Campaign.first.interview_sets.each do |set|
          expect(set.employee_interview.present?).to eq false
          expect(set.manager_interview.present?).to eq true
          expect(set.crossed_interview.present?).to eq false
        end
      end
    end

    context 'with interview_form answerable_by both' do
      context 'and not crossed' do
        let(:template) { create(:interview_form, answerable_by: 'both') }
        it 'should create a campaign and well formed interviews sets' do
          subject
          expect(Campaign.count).to eq 1
          Campaign.first.interview_sets.each do |set|
            expect(set.employee_interview.present?).to eq true
            expect(set.manager_interview.present?).to eq true
            expect(set.crossed_interview.present?).to eq false
          end
        end
      end

      context 'and crossed' do
        let(:template) { create(:interview_form, answerable_by: 'both', cross: true) }
        it 'should create a campaign and well formed interviews sets' do
          subject
          expect(Campaign.count).to eq 1
          Campaign.first.interview_sets.each do |set|
            expect(set.employee_interview.present?).to eq true
            expect(set.manager_interview.present?).to eq true
            expect(set.crossed_interview.present?).to eq true
          end
        end
      end
    end

  end
end
