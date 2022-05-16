# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Permission :can_create_employees', type: :feature, js: true do
  let(:user) do
    create(
      :user,
      access_level_int: :hr,
      can_read_employees: true,
      can_create_employees: can_create_employees
    )
  end

  before { login_as user }

  context 'a signed in user with read permission' do
    let(:can_create_employees) { false }
    scenario 'should not be able to create' do
      visit organisation_path
      expect(page).not_to have_selector("[data-handle='create-employee-ctas']")
    end
  end

  context 'a signed in user with create permission' do
    let(:can_create_employees) { true }
    scenario 'should be able to create' do
      visit organisation_path
      expect(page).to have_selector("[data-handle='create-employee-ctas']")
    end
  end
end
