# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Permission :can_create_contents', type: :feature, js: true do
  describe 'testing can create contents in catalogue path' do

    let(:can_create_contents) { false }
    let(:user) do
      create(
        :user,
        access_level_int: :hr,
        can_read_contents: true,
        can_create_contents: can_create_contents
      )
    end

    before { login_as user }

    context 'a signed in user with read permission' do
      let(:can_create_contents) { false }

      scenario 'should not be able to create' do
        visit catalogue_path

        expect(page).not_to have_selector("[data-handle='create-a-new-workshop-cta']")
      end
    end

    context 'a signed in user with create permission' do
      let(:can_create_contents) { true }

      scenario 'should be able to create' do
        visit catalogue_path

        find("[data-handle='create-a-new-workshop-cta']").click
        find("[name='content[title]']").set('toto')
        find(".modal-footer button[type='submit']").click
        expect(Content.count).to eq 1
        expect(page).to have_current_path edit_content_path(Content.last)
      end
    end
  end
end
