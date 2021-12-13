# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Home', type: :feature, js: true do
  context 'a not signed in user' do
    scenario 'should not be able to browse the home page' do
      visit root_path
      expect(page).to have_selector('#container-login')
    end
  end

  context 'a signed in user' do
    before do
      login_as create(:user)
    end
    scenario 'should be able to browse the dashboard page' do
      visit root_path
      expect(page).to have_selector('h4', text: 'Dashboard')
    end
  end
end