# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Permission :can_create_training_reports', type: :feature, js: true do
  let(:company) { create(:company) }

  context 'the training_reports form' do
    context 'a not signed in user' do
      scenario 'should not have access' do
        visit edit_trainings_reports_path
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'a signed in user without permission' do
      before { login_as create(:user, company: company) }
      scenario 'should not have access' do
        visit edit_trainings_reports_path
        expect(page).not_to have_current_path edit_trainings_reports_path
      end
    end

    context 'a signed in user with permission' do
      before { login_as create(:user, company: company, can_create_training_reports: true) }
      scenario 'should have access' do
        visit edit_trainings_reports_path
        expect(page).to have_current_path edit_trainings_reports_path
      end
    end
  end

  context 'the Create Training Report CTA' do
    context 'a not signed in user' do
      scenario 'should not have access' do
        visit trainings_reports_path
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'a signed in user without permission' do
      before { login_as create(:user, company: company) }
      scenario 'should not have access' do
        visit trainings_reports_path
        expect(page).not_to have_selector("[data-handle='create-a-training-report-cta']")
      end
    end

    context 'a signed in user with permission' do
      before { login_as create(:user, company: company, can_create_training_reports: true) }
      scenario 'should have access' do
        visit trainings_reports_path
        expect(page).to have_selector("[data-handle='create-a-training-report-cta']")
      end
    end
  end
end
