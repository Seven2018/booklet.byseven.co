# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Permission :can_create_employees', type: :feature, js: true do

  let(:user) do
    model = FactoryBot.build(:user,
                             can_read_employees: true,
                             can_create_employees: can_create_employees
    )
    model.skip_before_create = true
    model.save
    model
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
