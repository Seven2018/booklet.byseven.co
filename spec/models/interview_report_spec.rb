# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InterviewReport, type: :model do
  subject { InterviewReport.create interview_report_params }

  let(:company) { create(:company) }
  let(:tag_category) { create(:tag_category, company: company) }

  let(:campaign) do
    create(
      :campaign,
      owner: create(:user),
      interview_form: create(:interview_form),
      company: company
    )
  end


  let(:interview_report_params) do
    {
      company: company,
      start_time: 30.days.ago,
      end_time: 30.days.ago,
      tag_category: tag_category,
      mode: :classic
    }
  end

  describe "#no_duplicate_processing?" do
    context 'when no interview_report exists' do
      it 'validates the new instance' do
        expect(subject.persisted?).to be true
      end
    end

    context 'when an other interview_report exists' do
      context 'with an other signature' do
        context 'diff == mode' do
          let!(:other_interview_report) do
            create(:interview_report, interview_report_params.merge(mode: :data, state: state))
          end
          context 'and is enqueued' do
            let(:state) { :enqueued }
            it 'validates the new instance' do
              expect(subject.persisted?).to be true
            end
          end
          context 'and is started' do
            let(:state) { :started }
            it 'validates the new instance' do
              expect(subject.persisted?).to be true
            end
          end
          context 'and is done' do
            let(:state) { :done }
            it 'validates the new instance' do
              expect(subject.persisted?).to be true
            end
          end
          context 'and is failed' do
            let(:state) { :failed }
            it 'validates the new instance' do
              expect(subject.persisted?).to be true
            end
          end
        end

        context 'diff == company' do

          let(:other_company) { create(:company, siret: '0987654321abcd') }
          let!(:other_interview_report) do
            create(:interview_report, interview_report_params.merge(company: other_company, state: state))
          end
          context 'and is enqueued' do
            let(:state) { :enqueued }
            it 'validates the new instance' do
              expect(subject.persisted?).to be true
            end
          end
        end

        context 'diff == start_time' do
          let!(:other_interview_report) do
            create(:interview_report, interview_report_params.merge(start_time: 786.days.ago, state: state))
          end
          context 'and is enqueued' do
            let(:state) { :enqueued }
            it 'validates the new instance' do
              expect(subject.persisted?).to be true
            end
          end
        end

        context 'diff == end_time' do
          let!(:other_interview_report) do
            create(:interview_report, interview_report_params.merge(end_time: 786.days.ago, state: state))
          end
          context 'and is enqueued' do
            let(:state) { :enqueued }
            it 'validates the new instance' do
              expect(subject.persisted?).to be true
            end
          end
        end

        context 'diff == category' do
          let(:other_tag_category) { create(:tag_category, name: 'other name', company: company) }
          let!(:other_interview_report) do
            create(:interview_report, interview_report_params.merge(tag_category: other_tag_category, state: state))
          end
          context 'and is enqueued' do
            let(:state) { :enqueued }
            it 'validates the new instance' do
              expect(subject.persisted?).to be true
            end
          end
        end
      end
      context 'with the same signature' do
        let!(:other_interview_report) do
          create(:interview_report, interview_report_params.merge(state: state))
        end
        context 'and is enqueued' do
          let(:state) { :enqueued }
          it 'does not validate the new instance' do
            expect(subject.persisted?).to be false
          end
        end
        context 'and is started' do
          let(:state) { :started }
          it 'does not validate the new instance' do
            expect(subject.persisted?).to be false
          end
        end
        context 'and is done' do
          let(:state) { :done }
          it 'validates the new instance' do
            expect(subject.persisted?).to be true
          end
        end
        context 'and is failed' do
          let(:state) { :failed }
          it 'validates the new instance' do
            expect(subject.persisted?).to be true
          end
        end
      end
    end
  end
end