# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Permission :can_create_campaigns', type: :feature, js: true do
  let(:company) { create(:company) }

  context 'the campaign_draft form' do
    context 'a not signed in user' do
      scenario 'should not have access' do
        visit edit_campaign_draft_settings_path
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'a signed in user without permission' do
      before { login_as create(:user, company: company) }
      scenario 'should not have access' do
        visit edit_campaign_draft_settings_path
        expect(page).not_to have_current_path edit_campaign_draft_settings_path
      end
    end

    context 'a signed in user with permission' do
      before { login_as create(:user, company: company, can_create_campaigns: true) }
      scenario 'should have access' do
        visit edit_campaign_draft_settings_path
        expect(page).to have_current_path edit_campaign_draft_settings_path
      end
    end
  end

  context 'the Create Campaign CTA' do
    context 'a not signed in user' do
      scenario 'should not have access' do
        visit campaigns_path
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'a signed in user without permission' do
      before { login_as create(:user, company: company) }
      scenario 'should not have access' do
        visit campaigns_path
        expect(page).not_to have_selector("[data-handle='create-campaign-cta']")
      end
    end

    context 'a signed in user with permission' do
      before { login_as create(:user, company: company, can_create_campaigns: true) }
      scenario 'should have access' do
        visit campaigns_path
        expect(page).to have_selector("[data-handle='create-campaign-cta']")
      end
    end
  end
end
