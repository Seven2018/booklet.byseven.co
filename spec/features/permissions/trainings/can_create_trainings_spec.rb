# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Permission :can_create_trainings', type: :feature, js: true do
  let(:company) { create(:company) }

  context 'the campaign_draft form' do
    context 'a not signed in user' do
      scenario 'should not have access' do
        visit edit_training_draft_participants_path
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'a signed in user without permission' do
      before { login_as create(:user, company: company) }
      scenario 'should not have access' do
        visit edit_training_draft_participants_path
        expect(page).not_to have_current_path edit_training_draft_participants_path
      end
    end

    context 'a signed in user with permission' do
      before { login_as create(:user, company: company, can_create_trainings: true) }
      scenario 'should have access' do
        visit edit_training_draft_participants_path
        expect(page).to have_current_path edit_training_draft_participants_path
      end
    end
  end

  context 'the Book Training CTA' do
    context 'a not signed in user' do
      scenario 'should not have access' do
        visit trainings_path
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'a signed in user without permission' do
      before { login_as create(:user, company: company) }
      scenario 'should not have access' do
        visit trainings_path
        expect(page).not_to have_selector("[data-handle='book-training-cta']")
      end
    end

    context 'a signed in user with permission' do
      before { login_as create(:user, company: company, can_create_trainings: true) }
      scenario 'should have access' do
        visit trainings_path
        expect(page).to have_selector("[data-handle='book-training-cta']")
      end
    end
  end
end
