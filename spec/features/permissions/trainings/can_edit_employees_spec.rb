# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Permission :can_edit_employees', type: :feature, js: true do
  let(:company) { create(:company) }
  let(:other_user) { create(:user, email: 'johan.doe@gmail.com', company: company)}
  let(:user) do
    model = FactoryBot.build(:user,
                             can_read_employees: true,
                             can_edit_employees: can_edit_employees,
                             can_edit_permissions: can_edit_permissions

    )
    model.skip_before_create = true
    model.save
    model
  end

  before { login_as user }

  context 'a signed in user without edit permission' do
    context 'visiting his own profile' do
      let(:can_edit_employees) { false }
      let(:can_edit_permissions) { false }

      scenario 'should be able to update' do
        visit user_path(user)
        expect(page).to have_selector("[data-handle='edit-user-cta']")
        expect(page).to have_selector("[data-handle='edit-user-password-cta']")
      end
    end

    context 'visiting an other profile' do
      let(:can_edit_employees) { false }
      let(:can_edit_permissions) { false }

      scenario 'should not be able to update' do
        visit user_path(other_user)
        expect(page).not_to have_selector("[data-handle='edit-user-cta']")
        expect(page).not_to have_selector("[data-handle='edit-user-permissions-cta']")
        expect(page).not_to have_selector("[data-handle='edit-user-password-cta']")
      end
    end
  end

  context 'a signed in user with create permission' do
    let(:can_edit_employees) { true }
    let(:can_edit_permissions) { true }

    scenario 'should be able to update' do
      visit user_path(other_user)
      expect(page).to have_selector("[data-handle='edit-user-cta']")
      expect(page).to have_selector("[data-handle='edit-user-permissions-cta']")
      expect(page).to have_selector("[data-handle='edit-user-password-cta']")
    end
  end
end
