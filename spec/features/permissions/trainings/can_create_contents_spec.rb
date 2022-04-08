# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Permission :can_create_contents', type: :feature, js: true do
  let(:company) { create(:company) }
  let(:user) do
    create(
      :user,
      firstname: 'John',
      lastname: 'Doe',
      company: company,
      can_read_contents: true,
      can_create_contents: can_create_contents
    )
  end

  before { login_as user }

  context 'a signed in user with read permission' do
    let(:can_create_contents) { false }
    scenario 'should not be able to create' do
      visit catalogue_path
      # binding.pry
      find("[data-handle='create-a-new-workshop-cta']").click
      find("[name='content[title]']").set('toto')
      find(".modal-footer button[type='submit']").click

      expect(Content.count).to eq 0
      expect(page).to have_current_path root_path
    end
  end

  context 'a signed in user with create permission' do
    let(:can_create_contents) { true }
    scenario 'should be able to create a' do
      visit catalogue_path
      find("[data-handle='create-a-new-workshop-cta']").click
      find("[name='content[title]']").set('toto')
      find(".modal-footer button[type='submit']").click
      expect(Content.count).to eq 1
      expect(page).to have_current_path edit_content_path(Content.last)
    end
  end
end
