# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Interview, type: :model do
  let(:owner) { create(:user) }
  let(:manager) { create(:user, email: Faker::Internet.email) }
  let!(:employee) { create(:user, email: Faker::Internet.email, manager: manager) }
  let(:company) { create(:company) }
  let(:campaign) do
    create(:campaign,
      title: interview_form.title,
      owner: owner,
      interview_form: interview_form,
      company: company,
      campaign_type: campaign_type
    )
  end

  let(:interview_params) do {
    title: interview_form.title,
    campaign: campaign,
    interview_form: interview_form,
    employee: employee,
    interviewer: employee.manager,
    creator: owner
    }
  end

  let(:interview) { Interview.new(interview_params.merge(label: label)) }

  describe '#label_and_interview_form_match' do
    context 'with an interview created when source of truth was campaign_type' do
      context 'with a Whatever label' do
        let(:label) { 'Whatever' }
        let(:interview_form) { create(:interview_form, company: company) }

        context 'with campaign_type crossed' do
          let(:campaign_type) { :crossed }
          it('an interview can be created SKIPPING VALIDATION') { expect(interview.save).to be true }
        end

        context 'with campaign_type simple' do
          let(:campaign_type) { :simple }
          it('an interview can be created SKIPPING VALIDATION') { expect(interview.save).to be true }
        end
      end
    end

    context 'with an interview created once source of truth is template kind' do
      context 'with campaign_type one_to_one' do
        let(:campaign_type) { :one_to_one }
        context 'with a template answerable_by_employee_not_crossed' do
          let(:interview_form) { create(:interview_form, answerable_by: :employee, cross: false, company: company) }

          context 'with a Employee label' do
            let(:label) { 'Employee' }
            it('an interview can be created') { expect(interview.save).to be true }
          end

          context 'with a Manager label' do
            let(:label) { 'Manager' }
            it('an interview can NOT be created') { expect(interview.save).to be false }
          end

          context 'with a Crossed label' do
            let(:label) { 'Crossed' }
            it('an interview can NOT be created') { expect(interview.save).to be false }
          end

          context 'with a simple label' do
            let(:label) { 'Simple' }
            it('an interview can NOT be created') { expect(interview.save).to be false }
          end
        end

        context 'with a template answerable_by_manager_not_crossed' do
          let(:interview_form) { create(:interview_form, answerable_by: :manager, cross: false, company: company) }

          context 'with a Employee label' do
            let(:label) { 'Employee' }
            it('an interview can NOT be created') { expect(interview.save).to be false }
          end

          context 'with a Manager label' do
            let(:label) { 'Manager' }
            it('an interview can be created') { expect(interview.save).to be true }
          end

          context 'with a Crossed label' do
            let(:label) { 'Crossed' }
            it('an interview can NOT be created') { expect(interview.save).to be false }
          end

          context 'with a simple label' do
            let(:label) { 'Simple' }
            it('an interview can be created LEGACY') { expect(interview.save).to be true }
          end
        end


        context 'with a template answerable_by_both_not_crossed' do
          let(:interview_form) { create(:interview_form, answerable_by: :both, cross: false, company: company) }

          context 'with a Employee label' do
            let(:label) { 'Employee' }
            it('an interview can be created') { expect(interview.save).to be true }
          end

          context 'with a Manager label' do
            let(:label) { 'Manager' }
            it('an interview can be created') { expect(interview.save).to be true }
          end

          context 'with a Crossed label' do
            let(:label) { 'Crossed' }
            it('an interview can NOT be created') { expect(interview.save).to be false }
          end

          context 'with a simple label' do
            let(:label) { 'Simple' }
            it('an interview can be created LEGACY') { expect(interview.save).to be true }
          end
        end

        context 'with a template answerable_by_both_crossed' do
          let(:interview_form) { create(:interview_form, answerable_by: :both, cross: true, company: company) }

          context 'with a Employee label' do
            let(:label) { 'Employee' }
            it('an interview can be created') { expect(interview.save).to be true }
          end

          context 'with a Manager label' do
            let(:label) { 'Manager' }
            it('an interview can be created') { expect(interview.save).to be true }
          end

          context 'with a Crossed label' do
            let(:label) { 'Crossed' }
            it('an interview can be created') { expect(interview.save).to be true }
          end

          context 'with a simple label' do
            let(:label) { 'Simple' }
            it('an interview can be created LEGACY') { expect(interview.save).to be true }
          end
        end
      end
    end

  end
end
