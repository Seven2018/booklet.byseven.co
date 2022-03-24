# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Interview, type: :model do
  let(:owner) { create(:user) }
  let(:employee) { create(:user, email: 'employee@gmail.com') }
  let(:interview_form) { create(:interview_form, company: company) }
  let(:company) { create(:company) }
  let(:question) do
    create(:interview_question, question_type: 'rating', interview_form: interview_form)
  end
  let(:campaign) do
    create(:campaign,
      title: interview_form.title,
      owner: owner,
      interview_form: interview_form,
      company: company
    )
  end

  let(:interview_params) do {
    title: interview_form.title,
    campaign: campaign,
    interview_form: interview_form,
    employee: employee,
    creator: owner,
    interviewer: create(:user, email: Faker::Internet.email)
    }
  end

  let(:employee_interview) { create(:interview, interview_params.merge(label: 'Employee')) }
  let(:manager_interview) { create(:interview, interview_params.merge(label: 'Manager')) }
  let(:crossed_interview) { create(:interview, interview_params.merge(label: 'Crossed')) }

  let!(:employee_answer) do
    create(:interview_answer,
      answer: "5", interview_question: question, interview: employee_interview, user: employee
    )
  end
  let!(:manager_answer) do
    create(:interview_answer,
      answer: "5", interview_question: question, interview: manager_interview, user: owner
    )
  end
  let!(:crossed_answer) do
    create(:interview_answer,
      answer: "5", interview_question: question, interview: crossed_interview, user: owner
    )
  end

  describe '#locked_at' do

    context 'before an interview is locked' do
      it 'interview title can be updated' do
        expect(employee_interview.update(title: 'abc')).to be true
        expect(manager_interview.update(title: 'abc')).to be true
        expect(crossed_interview.update(title: 'abc')).to be true

        [employee_interview, manager_interview, crossed_interview].each &:reload

        expect(employee_interview.title).to eq('abc')
        expect(manager_interview.title).to eq('abc')
        expect(crossed_interview.title).to eq('abc')
      end

      it 'interview answer can be updated' do
        expect(employee_answer.update(answer: '1')).to be true
        expect(manager_answer.update(answer: '1')).to be true
        expect(crossed_answer.update(answer: '1')).to be true
      end

      it 'interview can be locked' do
        now = Time.zone.now
        expect(employee_interview.update(locked_at: now)).to be true
        expect(manager_interview.update(locked_at: now)).to be true
        expect(crossed_interview.update(locked_at: now)).to be true

        [employee_interview, manager_interview, crossed_interview].each &:reload

        expect(employee_interview.locked?).to be true
        expect(manager_interview.locked?).to be true
        expect(crossed_interview.locked?).to be true
      end
    end

    context 'after an interview is locked' do

      context 'when employee_interview' do
        before { employee_interview.lock!; employee_interview.reload; employee_answer.reload; }
        it 'its title or answer can NOT be updated' do
          expect(employee_interview.update(title: 'abc')).to be false
          expect(employee_answer.update(answer: '1')).to be false
        end

        context 'but when unlocked' do
          before { employee_interview.unlock!; employee_interview.reload; employee_answer.reload; }
          it 'its title or answer can be updated' do
            expect(employee_interview.update(title: 'abc')).to be true
            expect(employee_answer.update(answer: '1')).to be true
          end
        end
      end

      context 'when manager_interview' do
        before { manager_interview.lock!; manager_interview.reload; manager_answer.reload; }
        it 'its title or answer can NOT be updated' do
          expect(manager_interview.update(title: 'abc')).to be false
          expect(manager_answer.update(answer: '1')).to be false
        end

        context 'but when unlocked' do
          before { manager_interview.unlock!; manager_interview.reload; manager_answer.reload; }
          it 'its title or answer can be updated' do
            expect(manager_interview.update(title: 'abc')).to be true
            expect(manager_answer.update(answer: '1')).to be true
          end
        end
      end

      context 'when crossed_interview' do
        before { crossed_interview.lock!; crossed_interview.reload; crossed_answer.reload; }
        it 'its title or answer can NOT be updated' do
          expect(crossed_interview.update(title: 'abc')).to be false
          expect(crossed_answer.update(answer: '1')).to be false
        end

        context 'but when unlocked' do
          before { crossed_interview.unlock!; crossed_interview.reload; crossed_answer.reload; }
          it 'its title or answer can be updated' do
            expect(crossed_interview.update(title: 'abc')).to be true
            expect(crossed_answer.update(answer: '1')).to be true
          end
        end
      end

    end
  end
end
