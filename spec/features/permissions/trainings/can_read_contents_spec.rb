# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Permission :can_read_contents', type: :feature, js: true do
  let(:company) { create(:company) }

  context 'the interview_reports form' do
    context 'a not signed in user' do
      scenario 'should not have access' do
        visit catalogue_path
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'a signed in user without permission' do
      before { login_as create(:user, firstname: 'John', lastname: 'Doe', company: company) }
      scenario 'should not have access' do
        visit catalogue_path
        expect(page).not_to have_current_path catalogue_path
      end
    end

    context 'a signed in user with permission' do
      before { login_as create(:user, firstname: 'John', lastname: 'Doe', company: company, can_read_contents: true) }
      scenario 'should have access' do
        visit catalogue_path
        expect(page).to have_current_path catalogue_path
      end

      scenario 'should be able to create' do
        visit catalogue_path
        binding.pry
        find("[data-handle='add-a-template-cta']").click
        find("[name='interview_form[title]']").set('toto')
        find("#save_button").click

        expect(InterviewForm.count).to eq 1
        expect(page).to have_current_path edit_interview_form_path(InterviewForm.last)
      end
    end
  end
end
