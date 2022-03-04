# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Interview, type: :model do
  let(:owner) { create(:user) }
  let(:employee) { create(:user, email: 'employee@gmail.com') }
  let(:interview_form) { create(:interview_form) }
  let(:question) do
    create(:interview_question, question_type: 'rating', interview_form: interview_form)
  end
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
  let!(:hr_answer) do
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
        expect(hr_answer.update(answer: '1')).to be true
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
      before do
        [
          employee_interview,
          manager_interview,
          crossed_interview
        ].sample.lock!
        [employee_interview, manager_interview, crossed_interview].each &:reload
        [employee_answer, hr_answer, crossed_answer].each &:reload
      end

      it 'interview title can be updated' do
        expect(employee_interview.update(title: 'abc')).to be false
        expect(manager_interview.update(title: 'abc')).to be false
        expect(crossed_interview.update(title: 'abc')).to be false
      end

      it 'interview answer can be updated' do
        expect(employee_answer.update(answer: '1')).to be false
        expect(hr_answer.update(answer: '1')).to be false
        expect(crossed_answer.update(answer: '1')).to be false
      end

      it 'interview can not be unlocked' do
        expect(employee_interview.update(locked_at: nil)).to be false
        expect(manager_interview.update(locked_at: nil)).to be false
        expect(crossed_interview.update(locked_at: nil)).to be false
      end
    end
  end
end
