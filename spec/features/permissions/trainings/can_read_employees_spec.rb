# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Permission :can_read_employees', type: :feature, js: true do
  let(:company) { create(:company) }

  context 'the interview_reports form' do
    context 'a not signed in user' do
      scenario 'should not have access' do
        visit organisation_path
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'a signed in user without permission' do
      before { login_as create(:user, firstname: 'John', lastname: 'Doe', company: company) }
      scenario 'should not have access' do
        visit organisation_path
        expect(page).not_to have_current_path organisation_path
      end
    end

    context 'a signed in user with permission' do
      let(:user) do
        model = FactoryBot.build(:user,
                                 can_read_employees: true
        )
        model.skip_before_create = true
        model.save
        model
      end
      before { login_as user }

      scenario 'should have access' do
        visit organisation_path
        expect(page).to have_current_path organisation_path
      end
    end
  end
end
