# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Home', type: :feature, js: true do
  context 'a not signed in user' do
    scenario 'should not be able to browse the home page' do
      visit root_path
      expect(page).to have_selector("[name='user[email]'")
    end
  end

  context 'a signed in user' do
    let(:user) { create(:user) }
    before do
      login_as user
    end
    scenario 'should be redirected to the home page' do
      visit root_path
      expect(page).to have_selector('#navbar-home-logo')
    end
  end
end
