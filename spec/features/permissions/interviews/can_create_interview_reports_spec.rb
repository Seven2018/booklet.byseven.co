# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Permission :can_create_interview_reports', type: :feature, js: true do
  let(:company) { create(:company) }

  context 'the interview_reports form' do
    context 'a not signed in user' do
      scenario 'should not have access' do
        visit edit_interviews_reports_path
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'a signed in user without permission' do
      before { login_as create(:user, company: company) }
      scenario 'should not have access' do
        visit edit_interviews_reports_path
        expect(page).not_to have_current_path edit_interviews_reports_path
      end
    end

    context 'a signed in user with permission' do
      before { login_as create(:user, access_level_int: :hr, company: company, can_create_interview_reports: true) }
      scenario 'should have access' do
        visit edit_interviews_reports_path
        expect(page).to have_current_path edit_interviews_reports_path
      end
    end
  end

  context 'the Create Interview Report CTA' do
    context 'a not signed in user' do
      scenario 'should not have access' do
        visit interviews_reports_path
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'a signed in user without permission' do
      before { login_as create(:user, company: company) }
      scenario 'should not have access' do
        visit interviews_reports_path
        expect(page).not_to have_selector("[data-handle='create-an-interview-report-cta']")
      end
    end

    context 'a signed in user with permission' do
      before { login_as create(:user, access_level_int: :hr, company: company, can_create_interview_reports: true) }
      scenario 'should have access' do
        visit interviews_reports_path
        expect(page).to have_selector("[data-handle='create-an-interview-report-cta']")
      end
    end
  end
end
