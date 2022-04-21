# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Permission :can_edit_employees', type: :feature, js: true do
  let(:company) { create(:company) }
  let(:other_user) { create(:user, email: 'johan.doe@gmail.com')}
  let(:user) do
    create(
      :user,
      firstname: 'John',
      lastname: 'Doe',
      company: company,
      can_read_employees: true,
      can_edit_employees: can_edit_employees
    )
  end

  before { login_as user }

  context 'a signed in user without edit permission' do
    context 'visiting his own profile' do
      let(:can_edit_employees) { false }
      scenario 'should be able to update' do
        visit user_path(user)
        expect(page).to have_selector("[data-handle='edit-user-cta']")
        expect(page).to have_selector("[data-handle='edit-user-permissions-cta']")
        expect(page).to have_selector("[data-handle='edit-user-password-cta']")
      end
    end

    context 'visiting an other profile' do
      let(:can_edit_employees) { false }
      scenario 'should be able to update' do
        visit user_path(other_user)
        expect(page).not_to have_selector("[data-handle='edit-user-cta']")
        expect(page).not_to have_selector("[data-handle='edit-user-permissions-cta']")
        expect(page).not_to have_selector("[data-handle='edit-user-password-cta']")
      end
    end
  end

  context 'a signed in user with create permission' do
    let(:can_edit_employees) { true }
    scenario 'should be able to update' do
      visit user_path(other_user)
      expect(page).to have_selector("[data-handle='edit-user-cta']")
      expect(page).to have_selector("[data-handle='edit-user-permissions-cta']")
      expect(page).to have_selector("[data-handle='edit-user-password-cta']")
    end
  end
end
